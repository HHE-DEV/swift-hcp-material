import XCTest
import SharedHelpers
import SharedModels
@testable import PDFClient

import Parsing

final class PDFTests: XCTestCase {
//  func testReadingPDF() throws {
//    let url = URL(fileURLWithPath: #file)
//      .deletingLastPathComponent()
//      .appendingPathComponent("Resources")
//      .appendingPathComponent("test.pdf")
//    
//    let client = PDFClient.live
//    let pdf = try client.read(.init(url: url)).unwrap()
//    XCTAssertEqual(pdf["FVM4X2400BL"], 1346)
//    XCTAssertEqual(pdf["EHK07AKB"], 132)
//    
//    let pdf2 = try client.read(.init(url: url, ignorePages: [1])).unwrap()
//    XCTAssertEqual(pdf2["FVM4X2400BL"], 1346)
//    XCTAssertEqual(pdf2["EHK07AKB"], 132)
//  }
  
  func test_client2() throws {
    let client = PDFClient.live
    let pdf = try client.load(.init(url: testPDFURL(), ignorePages: [1])).unwrap()
    let parsed = try client.parse(pdf).unwrap()
    
    for (key, value) in expectedPDFDictionary {
      XCTAssertEqual(parsed[key], value)
    }
  }
  
}

func testPDFURL() -> URL {
  URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .appendingPathComponent("Resources")
    .appendingPathComponent("test.pdf")
}

//extension Result where Failure: Error {
//
//  func unwrap() throws -> Success {
//    switch self {
//    case let .success(value): return value
//    case let .failure(error): throw error
//    }
//  }
//}

fileprivate let expectedPDFDictionary: [String: Double] = [
  "FEM4X1800BL": 901,
  "FEM4X2400CL": 989,
  "FEM4X3000BL": 1020,
  "FEM4X3600BL": 1113,
  "FEM4X4200BL": 1252,
  "FEM4X4800BL": 1372,
  "FEM4X6000BL": 1348,
  "FCM4X2400AL": 1346,
  "FCM4X3600AL": 1567,
  "FCM4X4800AL": 1794,
  "FCM4X6000AL": 1871,
  "FVM4X2400BL": 1346,
  "FVM4X3600BL": 1567,
  "FVM4X4800BL": 1785,
  "FVM4X6000BL": 1871,
  "EHK05AKB": 107,
  "EHK05AKN": 67.85,
  "EHK07AKB": 132,
  "EHK10AKB": 134,
  "EHC09AKCN": 158,
  "EHK15AKB": 203,
  "EHK20AKB": 260,
  "EHK25AHCF": 356,
  "EHK30AHCF": 376,
  "FXM4X1800AL": 956,
  "FXM4X2400AL": 1007,
  "FXM4X3000AL": 1074,
  "FXM4X3600AL": 1160,
  "FXM4X4200AL": 1298,
  "FXM4X4800AL": 1429,
  "FXM4X6000AL": 1516,
  "FEM4P1800AL": 789,
  "FEM4P2400AL": 837,
  "FEM4P3000AL": 897,
  "FEM4P3600AL": 996,
  "FEM4P4200AL": 1129,
  "FEM4P4800AL": 1259,
  "EBAC01DFS": 23.10,
  "EBAC02DFA": 90.60
]

fileprivate let pdfParsingInput = """
 1 Yrs No Hassle
   Part Number Dimensions HxWxD (in) Price
   FEM4X1800BL 42 11/16 x 14 5/16 x 22 1/16 901.00
  FEM4X2400CL 49 5/8 x 17 5/8 x 22 1/16 989.00
  FEM4X3000BL 49 5/8 x 17 5/8 x 22 1/16 1020.00
  FEM4X3600BL 49 5/8 x 17 5/8 x 22 1/16 1113.00
  FEM4X4200BL 49 5/8 x 21 1/8 x 22 1/16 1252.00
  FEM4X4800BL 49 5/8 x 21 1/8 x 22 1/16 1372.00
  FEM4X6000BL 49 5/8 x 21 1/8 x 22 1/16 1348.00
   10 Yrs No Hassle
   Part Number Dimensions H x W x D (in) Price
   FCM4X2400AL 42 11/16 x 17 5/8 x 22 1/16 1346.00
  FCM4X3600AL 53 7/16 x 21 1/8 x 22 1/8 1567.00
  FCM4X4800AL 53 7/16 x 21 1/8 x 22 1/8 1794.00
  FCM4X6000AL 59 3/16 x 24 11/16 x 22 1/8 1871.00
  10 Yrs No Hassle
   Part Number Dimensions HxWxD (in) Price
   FVM4X2400BL 42 11/16 x 17 5/8 x 22 1/16 1346.00
  FVM4X3600BL 53 7/16 x 21 1/8 x 22 1/8 1567.00
  FVM4X4800BL 53 7/16 x 21 1/8 x 22 1/8 1785.00
  FVM4X6000BL 59 3/16 x 24 11/16 x 22 1/8 1871.00
  Standard Air Handlers
   Part Number Electric Heaters for Price
   EHK05AKB FV/FS/FE/FX 107.00
  EHK05AKN FV/FS/FE/FX 67.85
  EHK07AKB FV/FS/FE/FX 132.00
  EHK10AKB FV/FS/FE/FX 134.00
  EHC09AKCN FC 158.00
  EHK15AKB FV/FS/FE/FX 203.00
  EHK20AKB FV/FS/FE/FX 260.00
  EHK25AHCF FV/FS/FE/FX 356.00
  EHK30AHCF FV/FS/FE/FX 376.00
  5 Yrs No Hassle
    Part Number Dimensions HxWxD (in) Price
  FXM4X1800AL 49 5/8 x 17 5/8 x 22 1/16 956.00
  FXM4X2400AL 49 5/8 x 17 5/8 x 22 1/16 1007.00
  FXM4X3000AL 53 7/16 x 21 1/8 x 22 1/16 1074.00
  FXM4X3600AL 49 5/8 x 21 1/8 x 22 1/16 1160.00
  FXM4X4200AL 49 5/8 x 21 1/8 x 22 1/16 1298.00
  FXM4X4800AL 53 7/16 x 24 11/16 x 22 1/16 1429.00
  FXM4X6000AL 59 3/16 x 24 11/16 x 22 1/16 1516.00
  Standard Air Handlers
 1 Yrs No Hassle
   Part Number Dimenstions HxWxD (in) Price
   FEM4P1800AL 42 11/16 x 14 5/16 x 22 1/16 789.00
  FEM4P2400AL 42 11/16 x 14 5/16 x 22 1/16 837.00
  FEM4P3000AL 49 5/8 x 17 5/8 x 22 1/16 897.00
  FEM4P3600AL 49 5/8 x 17 5/8 x 22 1/16 996.00
  FEM4P4200AL 49 5/8 x 21 1/8 x 22 1/16 1129.00
  FEM4P4800AL 49 5/8 x 21 1/8 x 22 1/16 1259.00
    Part Number Description Price
   EBAC01DFS Downflow Kit sloped coils 23.10
  EBAC02DFA Dowflown Kit A coils 90.60
  Confidential for HOUSH-THE HOME ENERGY EXPERTS VER020322
Air Handlers
Ion System Variable Speed Fan Coil
TXV, Communicating, Variable Speed ECM Motor **Requires Observer Control**
TXV, Variable Speed ECM Motor
TXV, High Efficiency ECM Motor
TXV, High Efficiency ECM Motor 14 SEER only
   Electric Heaters Standard
 PISTON, HIGH EFFICIENCY MOTOR, NO 14 SEER RATINGS
Accessories
  14
The Corken Steel Products Company Since 1955
HVAC Equipment
"""
