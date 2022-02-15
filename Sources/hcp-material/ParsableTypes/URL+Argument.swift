import ArgumentParser
import Foundation

extension URL: ExpressibleByArgument {

  /// Parses a command line string argument into a file url.
  ///
  /// - Parameters:
  ///   - argument: The command line argument
  public init?(argument: String) {
    let argument = NSString(string: argument).expandingTildeInPath
    self.init(fileURLWithPath: argument)
  }
}
