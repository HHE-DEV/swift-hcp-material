import Foundation

public struct CSV: Equatable {
  
  public let header: [String]
  public let rows: [[String]]
  
  public init(
    header: [String],
    rows: [[String]]
  ) throws {
    self.rows = try Self.validate(rows: rows, for: header)
    self.header = header
  }
  
  public init(_ content: [[String]]) throws {
    guard let header = content.first else {
      throw CSVHeaderNotFoundError()
    }
    let rows = Array(content.suffix(from: 1))
    try self.init(header: header, rows: rows)
  }
 
  @discardableResult
  public static func validate(rows: [[String]], for header: [String]) throws -> [[String]]{
    let expectedCount = header.count
    
    let invalidRows = zip(rows.indices, rows)
      .filter( { $0.1.count != expectedCount })
      .map { ($0.0 + 1, $0.1 )}
    
    guard invalidRows.count == 0 else {
      throw InvalidRowsError(expectedCount: expectedCount, invalidRows: invalidRows)
    }
    
    return rows
  }
}
  
// MARK: Errors
public struct CSVHeaderNotFoundError: Error { }

public struct InvalidRowsError: Error {
  public let expectedCount: Int
  public let invalidRows: [(Int, [String])]
}
