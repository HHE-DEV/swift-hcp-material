import ArgumentParser
import CSVClient
import Foundation
import PDFClient
import SharedHelpers

struct Parse: ParsableCommand {
  
  static let configuration: CommandConfiguration = .init(
    commandName: "parse",
    abstract: "Parses a pdf or csv file and prints the parsed results.",
    discussion: "",
    version: VERSION ?? "0.0.1",
    shouldDisplay: true,
    subcommands: [CSV.self, PDF.self],
    defaultSubcommand: PDF.self,
    helpNames: nil
  )
}

extension Parse {
  
  struct CSV: ParsableCommand {
    
    static let configuration: CommandConfiguration = .init(
      commandName: "csv",
      abstract: "Parses the input csv file and prints the parsed results.",
      discussion: "",
      version: VERSION ?? "0.0.1",
      shouldDisplay: true,
      subcommands: [],
      defaultSubcommand: nil,
      helpNames: nil
    )
    
    @Argument(
      help: "The csv url to load and parse.",
      completion: .file(extensions: ["csv"])
    )
    var csv: URL
    
    func run() throws {
      let client = CSVClient.live
      let parsed = try client.load(csv).unwrap()
      
      print("Header")
      print(parsed.header.joined(separator: ","))
      print("Rows")
      print(parsed.rows.map { $0.joined(separator: ",") }.joined(separator: "\n"))
    }
  }
  
  struct PDF: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
      commandName: "pdf",
      abstract: "Parses a pdf and prints the parsed results.",
      discussion: "",
      version: VERSION ?? "0.0.1",
      shouldDisplay: true,
      subcommands: [],
      defaultSubcommand: nil,
      helpNames: nil
    )
    
    @OptionGroup var ignorePagesOption: IgnorePagesOption
    
    @Argument(
      help: "The pdf file path to parse.",
      completion: .file(extensions: ["pdf"])
    )
    var pdf: URL
    
    func run() throws {
      let client = PDFClient.live
      let request = PDFClient.LoadRequest(url: pdf, ignorePages: ignorePagesOption.ignorePages)
      let pdf = try client.load(request).unwrap()
      let result = try client.parse(pdf).unwrap()
      print("")
      print("Successfully parsed pdf: \(request.url.path)")
      print("")
      for (key, value) in result {
        print("\(key):\t\t\(value)")
      }
    }
  }
}
