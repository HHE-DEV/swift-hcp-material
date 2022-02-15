import ArgumentParser
import Foundation

@main
struct HCPMaterial: ParsableCommand {
  
  static let configuration: CommandConfiguration = .init(
    commandName: "hcp-material",
    abstract: "",
    discussion: "",
    version: VERSION ?? "0.0.1",
    shouldDisplay: true,
    subcommands: [Update.self, Parse.self],
    defaultSubcommand: Update.self,
    helpNames: nil
  )
}
