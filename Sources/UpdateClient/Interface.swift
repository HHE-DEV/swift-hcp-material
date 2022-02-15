import Foundation
import SharedModels

public struct UpdateClient {
  
  public var update: (CSV, PDF) -> Result<UpdateResult, Error>
  
  public init(
    update: @escaping (CSV, PDF) -> Result<UpdateResult, Error>
  ) {
    self.update = update
  }
  
  public struct UpdateResult: Equatable {
    public let csv: CSV
    public let updatedRowCount: Int
    
    public init(csv: CSV, updatedRowCount: Int) {
      self.csv = csv
      self.updatedRowCount = updatedRowCount
    }
  }
}
