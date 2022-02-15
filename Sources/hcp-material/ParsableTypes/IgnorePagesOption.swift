import ArgumentParser
import Foundation

struct IgnorePagesOption: ParsableArguments {
  
  @Option(
    name: [.short, .customLong("ignoring-page")],
    help: "A page to ignore while parsing the pdf"
  )
  var ignorePages: [Int] = []
  
}
