import Foundation
import SharedModels

extension CSV {

  func update(
    with updates: Dictionary<String, Double>
  ) throws -> UpdateClient.UpdateResult {
    
    var updatedCount = 0
    guard let partNumberIndex = partNumberIndex,
          let costIndex = costIndex
    else {
      throw InvalidCSVError()
    }
    
    let rows = self.rows.map { row -> [String] in
      let partNumber = row[partNumberIndex]
      
      guard let updatedCost = updates[partNumber] else {
        return row.appending(row[costIndex])
      }
      updatedCount += 1
      return row.appending(updatedCost.currencyString)
    }
    
    let csv = try CSV(header: updatedHeader, rows: rows)
    return .init(csv: csv, updatedRowCount: updatedCount)
  }
  
}

extension CSV {
  
  fileprivate var partNumberIndex: Int? { header.firstIndex(of: "part_number") }
  fileprivate var costIndex: Int? { header.firstIndex(of: "cost") }
  
  fileprivate var updatedHeader: [String] {
    header.appending("updated_cost")
  }
  
}


extension Array {
  
  fileprivate func appending(_ element: Element) -> Self {
    self + [element]
  }
}

extension Double {
  var currencyString: String { currencyFormmater.string(for: self)! }
}

struct InvalidCSVError: Error { }

fileprivate let currencyFormmater: NumberFormatter = {
  let formatter = NumberFormatter()
  formatter.usesGroupingSeparator = false
  formatter.numberStyle = .currency
  return formatter
}()
