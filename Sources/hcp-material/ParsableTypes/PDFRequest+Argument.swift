import ArgumentParser
import Foundation
import PDFClient

struct PDFRequest: ParsableArguments {
  
  @Option(
    name: [.short, .customLong("pdf")],
    help: "The pdf url",
    completion: .file(extensions: ["pdf"])
  )
  var pdfURL: URL
 
  @OptionGroup var ignorPagesOption: IgnorePagesOption
  
  var loadRequest: PDFClient.LoadRequest {
    .init(url: pdfURL, ignorePages: ignorPagesOption.ignorePages)
  }
}
