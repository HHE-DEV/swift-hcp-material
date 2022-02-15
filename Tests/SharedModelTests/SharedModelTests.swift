import XCTest
@testable import SharedModels

final class SharedModelTests: XCTestCase {
  
  static let testHeader = ["foo", "bar", "baz"]
  
  let invalidRowCSV: [[String]] = [
    ["foo", "bar", "baz"],
    ["foo", "bar", "baz"],
    ["foo", "bar"],
  ]
  
  func test_CSV_initializes_with_valid_content() throws {
    let csv = try CSV.init(.init(repeating: Self.testHeader, count: 10))
    let csv2 = try CSV.init(header: Self.testHeader, rows: .init(repeating: Self.testHeader, count: 9))
    XCTAssertEqual(csv, csv2)
  }
  
  func test_CSV_throws_error_with_invalid_content() {
    XCTAssertThrowsError(try CSV.init([]))
    XCTAssertThrowsError(try CSV.init(invalidRowCSV))
  }
}
