import Foundation
import SharedModels

extension PDFClient {
  
  public static let live = Self.init(
    load: { request in
      PDF.load(request)
    },
    parse: { pdf in
      Result { try pdf.parse() }
    }
  )
}

