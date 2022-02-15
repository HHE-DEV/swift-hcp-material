import Foundation

public struct PDF: Equatable {
  
  public var contents: String
  
  public init(contents: String) {
    self.contents = contents
  }
}
