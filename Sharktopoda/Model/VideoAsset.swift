//
//  VideoAsset.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import AVFoundation

struct VideoAsset {
  let uuid: String
  let url: URL
  
  var avAsset: AVAsset
  var localizations: [Localization] = []

  init(uuid: String, url: URL) {
    self.uuid = uuid
    self.url = url
    self.avAsset = AVAsset(url: url)
  }
}
