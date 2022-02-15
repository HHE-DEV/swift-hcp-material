import ArgumentParser
import CSVClient
import Foundation
import PDFClient
import SharedHelpers
import UpdateClient

struct Update: ParsableCommand {
  
  static let configuration: CommandConfiguration = .init(
    commandName: "update",
    abstract: "Reads pricing from a pdf and updates a material csv file",
    discussion: "",
    version: VERSION ?? "0.0.1",
    shouldDisplay: true,
    subcommands: [],
    defaultSubcommand: nil,
    helpNames: nil
  )
 
  @OptionGroup var pdfRequest: PDFRequest
  
  @Option(
    name: [.short, .customLong("csv")],
    help: "The input csv document",
    completion: .file(extensions: ["csv"])
  )
  var csvURL: URL
  
  @Option(
    name: [.short, .customLong("output")],
    help: "The output path",
    completion: .directory
  )
  var outputURL: URL

  func run() throws {
    
    let csvClient = CSVClient.live
    let pdfClient = PDFClient.live
    let updateClient = UpdateClient.live(parsePDF: pdfClient.parse)
    let outputURL = self.outputURL
      .appendingPathComponent("\(Date().isosec)-material-output.csv")
      
    let csv = try csvClient.load(csvURL).unwrap()
    let pdf = try pdfClient.load(pdfRequest.loadRequest).unwrap()
    let updates = try updateClient.update(csv, pdf).unwrap()
    
    try csvClient.write(updates.csv, outputURL).unwrap()
    
    print("")
    print("Found '\(updates.updatedRowCount)' updates.")
    print("")
    print(outputURL.path)
  }
}

fileprivate extension Date {
  var isosec: String {
    isosecFormatter.string(from: self)
  }
}

/// The format for an `isosec` string or date.
fileprivate let isosecFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyyMMddHHmmss"
  return formatter
}()
