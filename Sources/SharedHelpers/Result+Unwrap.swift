import Foundation

extension Result where Failure: Error {
  
  /// Unwraps the result or throws an error if not successful.
  public func unwrap() throws -> Success {
    switch self {
    case let .success(value): return value
    case let .failure(error): throw error
    }
  }
}
