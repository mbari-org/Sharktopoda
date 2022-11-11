//
//  LocalizationsMessages.swift
//  Created for Sharktopoda on 11/11/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

extension Localizations {
  func sendSelectedMessage() {
    if let client = UDP.sharktopodaData.udpClient {
      let message = ClientSelectLocalizations(videoId: videoAsset.id, ids: selectedIds())
      client.process(message)
    }
  }
  
  func sendUpdateMessage(ids: [String]) {
    if let client = UDP.sharktopodaData.udpClient {
      let message = ClientUpdateLocalizations(videoId: videoAsset.id,
                                              localizations: ids.map { storage[$0]! })
      client.process(message)
    }
  }
  
}
