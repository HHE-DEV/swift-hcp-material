import XCTest
import SharedHelpers
import SharedModels
import PDFClient
@testable import UpdateClient

final class UpdateTests: XCTestCase {
  
  func test_currency_formatting() {
    let input = Double(1817.15)
    let string = input.currencyString
    XCTAssertEqual(string, "$1817.15")
  }
  
  func test_update_client() throws {
    let pdfClient = PDFClient.live
    let updateClient = UpdateClient.live(parsePDF: pdfClient.parse)
    let updates = try updateClient.update(.testing, .testing).unwrap()
    XCTAssertEqual(updates.updatedRowCount, 1)
    let expectedRows = [
      ["foo", "$1234", "$1235.00"],
      ["bar", "$4567", "$4567"]
    ]
    XCTAssertEqual(updates.csv.rows, expectedRows)
  }
}

extension CSV {
  
  static let testing = try! Self.init(
    header: ["part_number", "cost"],
    rows: [
      ["foo", "$1234"],
      ["bar", "$4567"]
    ]
  )
}

extension PDF {
  
  static let testing = Self.init(
    contents: """
    foo 1235.00
    """
  )
}
