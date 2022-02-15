import Foundation

extension CSVClient {
  
  /// The live ``CSVClient`` interface.
  public static let live = Self.init(
    load: { url in
      Result {
        try .parse(string: String(contentsOf: url))
      }
    },
    write: { csv, url in
      Result {
        try csv.string.write(to: url, atomically: true, encoding: .utf8)
      }
    }
  )
}
