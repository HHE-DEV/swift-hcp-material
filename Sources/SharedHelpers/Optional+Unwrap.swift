import Foundation

extension Optional {
  
  /// Unwraps the optional or throws an error.
  ///
  /// - Parameters:
  ///   - error: The error to throw if the value is nil.
  public func unwrap<E>(or error: E) throws -> Wrapped where E: Error {
    switch self {
    case let .some(value): return value
    case .none: throw error
    }
  }
}
