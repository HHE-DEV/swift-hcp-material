import Foundation
import SharedModels

public struct PDFClient {
  
  public var load: (LoadRequest) -> Result<PDF, Error>
  public var parse: (PDF) -> Result<[String: Double], Error>
  
  public init(
    load: @escaping (LoadRequest) -> Result<PDF, Error>,
    parse: @escaping (PDF) -> Result<[String: Double], Error>
  ) {
    self.load = load
    self.parse = parse
  }
}

extension PDFClient {
  
  /// Represents a request to read a pdf contents.
  public struct LoadRequest {
    
    /// The url to the pdf.
    public let url: URL
    
    /// Any pages to ignore during the parsing process.
    public let ignorePages: [Int]
    
    /// Create a new request.
    ///
    /// - Parameters:
    ///   - url: The url to the pdf.
    ///   - ignorePages: Any pages to ignore during the parsing process.
    public init(url: URL, ignorePages: [Int] = []) {
      self.url = url
      self.ignorePages = ignorePages
    }
  }
}
