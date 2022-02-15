import XCTest
import SharedHelpers
import SharedModels
@testable import CSVClient

final class CSVClient2Tests: XCTestCase {
  
  func test_live_client() throws {
    let client = CSVClient.live
    let csv = try client.load(testCSVURL()).unwrap()
    XCTAssertEqual(csv.header.count, 14)
    XCTAssertEqual(csv.rows.count, 362)
    
    let csvFromOutputString = try CSV.parse(string: csv.string)
    XCTAssertEqual(csv, csvFromOutputString)
    
    let outputURL = FileManager.default.temporaryDirectory
      .appendingPathComponent("test_client.csv")
    try client.write(csv, outputURL).unwrap()
    let loadedCSV = try client.load(outputURL).unwrap()
    XCTAssertEqual(csv, loadedCSV)
    
    try! FileManager.default.removeItem(at: outputURL)
  }
  
  func test_double_from_currency_string() {
    let formater = NumberFormatter()
    formater.numberStyle = .currency
    formater.decimalSeparator = ""
    let nsCost = formater.number(from: "$1800.15")
    XCTAssertNotNil(nsCost)
    XCTAssertEqual(Double(truncating: nsCost!), 1800.15)
  }
}

fileprivate func testCSVURL() -> URL {
  URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .appendingPathComponent("Resources")
    .appendingPathComponent("test.csv")
}
