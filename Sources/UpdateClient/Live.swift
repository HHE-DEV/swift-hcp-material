import Foundation
import SharedModels

extension UpdateClient {
  
  public static func live(
    parsePDF: @escaping (PDF) -> Result<Dictionary<String, Double>, Error>
  ) -> Self {
    .init(update: { csv, pdf in
      parsePDF(pdf).update(csv: csv)
    })
  }
}
