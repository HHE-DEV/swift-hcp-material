import Foundation
import SharedModels

//extension UpdateClient {
//  
//  public static let live = Self.init(
//    write: { updates, url in
//      Result(catching: { try updates.output.write(to: url, atomically: true, encoding: .utf8) })
//    }
//  )
//}

extension UpdateClient {
  
  public static func live(
    parsePDF: @escaping (PDF) -> Result<Dictionary<String, Double>, Error>
  ) -> Self {
    .init(update: { csv, pdf in
      parsePDF(pdf).update(csv: csv)
    })
  }
  
//  public static let live = Self.init(
//    update: { csv, pdf in
//      Result {
//        try csv.update(with: .init(pdf: pdf))
//      }
//    }
//  )
}

extension Result where Success == Dictionary<String, Double>, Failure == Error {
  
  func update(csv: CSV) -> Result<UpdateClient.UpdateResult, Error> {
    flatMap { updates in
      do {
        return .success(try csv.update(with: updates))
      } catch {
        return .failure(error)
      }
    }
  }
}
