import Foundation
import Parsing
import PDFKit
import SharedHelpers
import SharedModels

extension PDF {
  
  /// Loads the pdf contents with the given request.
  ///
  /// - Parameters:
  ///   - request: The load request for loading the pdf contents.
  static func load(_ request: PDFClient.LoadRequest) -> Result<PDF, Error> {
    readPDF(request)
      .map(PDF.init(contents:))
  }
  
  /// Parses the pdf contents into key / value pairs of potential part numbers and
  /// costs.
  func parse() throws -> [String: Double] {
    try pdfParser
      .parse(contents[...].utf8)
      .unwrap(or: PDFParseError())
  }
}

// MARK: - Loading

/// Reads the pdf contents from the url and turns it into one large string.
///
/// - Parameters:
///   - url: The url to read the pdf contents from.
fileprivate func readPDF(_ request: PDFClient.LoadRequest) -> Result<String, Error> {
  guard let pdf = PDFDocument(url: request.url) else {
    return .failure(PDFLoadingError())
  }
  
  let pageCount = pdf.pageCount
  let documentContent = NSMutableAttributedString()
  
  for i in  0 ..< pageCount {
    guard !request.ignorePages.contains(i + 1) else { continue }
    guard let page = pdf.page(at: i) else { continue }
    guard let pageContent = page.attributedString else { continue }
    documentContent.append(pageContent)
  }
  
  return .success(documentContent.mutableString as String)
}

// MARK: Parsing
fileprivate let field = Parse {
  Skip {
    Prefix { $0 == .init(ascii: " ") || $0 == .init(ascii: "\t") }
  }
  Prefix { $0 != .init(ascii: " ") && $0 != .init(ascii: "\n") }
}.map {
  String(Substring($0))
}

fileprivate let line = Many {
  field
} separator: {
  " ".utf8
}

fileprivate let pdfParser = Many {
  line
} separator: {
  "\n".utf8
}.map {
  $0.partNumbersAndCost
}

extension Array where Element == String {
  
  fileprivate var keyAndDoublePair: (key: String, value: Double)? {
    guard count >= 2 else { return nil }
    guard let last = self.last, let double = Double(last) else { return nil }
    return (first!, double)
  }
}

extension Array where Element == [String] {
  
  fileprivate var partNumbersAndCost: Dictionary<String, Double> {
    reduce(into: [String: Double]()) { output, next in
      guard let keyValue = next.keyAndDoublePair else { return }
      output[keyValue.key] = keyValue.value
    }
  }
}

// MARK: - Errors
public struct PDFLoadingError: Error { }

public struct PDFParseError: Error { }
