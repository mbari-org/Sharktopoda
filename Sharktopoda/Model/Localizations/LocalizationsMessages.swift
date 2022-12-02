//
//  LocalizationsMessages.swift
//  Created for Sharktopoda on 11/11/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

extension Localizations {
  func sendIdsMessage(_ command: ClientCommand, ids: [String]) {
    if let client = UDP.sharktopodaData.udpClient {
      let message = ClientMessageLocalizationIds(command,
                                                 videoId: id,
                                                 ids: ids)
      client.process(message)
    }
  }
  
  func sendLocalizationsMessage(_ command: ClientCommand, ids: [String]) {
    if let client = UDP.sharktopodaData.udpClient {
      let message = ClientMessageLocalizations(command,
                                               videoId: id,
                                               localizations: ids.map { storage[$0]! })
      client.process(message)
    }
  }
  
}
