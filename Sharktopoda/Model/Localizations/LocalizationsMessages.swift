//
//  LocalizationsMessages.swift
//  Created for Sharktopoda on 11/11/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

extension LocalizationData {
  func sendIdsMessage(_ command: ClientCommand, ids: [String]) {
    if let client = UDP.sharktopodaData.udpClient {
      let message = ClientMessageLocalizationIds(command,
                                                 videoId: videoAsset.id,
                                                 ids: ids)
      client.process(message)
    }
  }
  
  func sendLocalizationsMessage(_ command: ClientCommand, localization: Localization) {
    if let client = UDP.sharktopodaData.udpClient {
      let message = ClientMessageLocalizations(command,
                                               videoId: videoAsset.id,
                                               localizations: [localization])
      client.process(message)
    }
  }
  
}
