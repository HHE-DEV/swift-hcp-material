import Foundation
import SharedModels

/// Represents interactions with the filesystem for a ``CSV`` item.
public struct CSVClient {
  
  /// Load the ``CSV`` from a file url.
  public var load: (URL) -> Result<CSV, Error>
  
  /// Write the ``CSV`` to the file url.
  public var write: (CSV, URL) -> Result<Void, Error>
  
  /// Create a new ``CSVClient``.
  ///
  /// - Parameters:
  ///   - load: Load the csv from a file url.
  ///   - write: Write the csv to a file url.
  public init(
    load: @escaping (URL) -> Result<CSV, Error>,
    write: @escaping (CSV, URL) -> Result<Void, Error>
  ) {
    self.load = load
    self.write = write
  }
}
