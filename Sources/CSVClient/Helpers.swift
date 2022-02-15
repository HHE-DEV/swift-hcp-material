import Foundation
import Parsing
import SharedHelpers
import SharedModels

extension CSV {
  
   /// Attempts to parses csv rows from a string.
  ///
  /// - Parameters:
  ///   - string: The input string to parse into a CSV item.
  fileprivate static func parse(string: String) throws -> [[String]] {
    try csvParser.parse(string[...].utf8)
      .unwrap(or: CSVParsingError())
      .compactMap { ($0.count == 1 && $0[0].isEmpty) ? nil : $0 }
  }
  
  /// Attempts to parses a ``CSV`` item from a string.
  ///
  /// - Parameters:
  ///   - string: The input string to parse into a CSV item.
  public static func parse(string: String) throws -> Self {
    return try .init(Self.parse(string: string))
  }
  
  /// Converts a ``CSV`` item into a string that can be written to a file.
  public var string: String {
    header.csvString
    + .newLine
    + rows.map(\.csvString).joined(separator: .newLine)
  }
}

// MARK: - Parsing
fileprivate let plainField = Prefix { $0 != .init(ascii: ",") && $0 != .init(ascii: "\n") }

fileprivate let quotedField = Parse {
  "\"".utf8
  Prefix { $0 != .init(ascii: "\"") }
  "\"".utf8
}

fileprivate let complexQuotedField = Parse {
  "\"".utf8
  Prefix { $0 != .init(ascii: "\"") }
  "\"".utf8
  ",".utf8
}

fileprivate let field = OneOf {
  OneOf {
    quotedField
    complexQuotedField
  }
  plainField
}
  .map { String(Substring($0)) }

fileprivate let line = Many {
  field
} separator: {
  ",".utf8
}

fileprivate let csvParser = Many {
  line
} separator: {
  "\n".utf8
}

// MARK: String Operations
fileprivate extension String {
  static var newLine: String { "\n" }
  static var comma: String { "," }
  var quoted: String { "\"\(self)\"" }
}

fileprivate extension Character {
  static var newLine: String { "\n" }
}

fileprivate extension Array where Element == String {
  var csvString: String {
    map(\.quoted).joined(separator: .comma)
  }
}

// MARK: Errors
public struct CSVParsingError: Error { }
