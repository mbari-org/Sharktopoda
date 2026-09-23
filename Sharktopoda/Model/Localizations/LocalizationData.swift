//
//  LocalizationData.swift
//  Created for Sharktopoda on 10/6/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import SwiftUI

class LocalizationData {
  var storage = [String: Localization]()
  var pauseFrames = [LocalizationFrame]()
  var selected = Set<String>()

  let videoAsset: VideoAsset

  init(videoAsset: VideoAsset) {
    self.videoAsset = videoAsset
  }
}

// MARK: Enums
extension LocalizationData {
  enum PutAction {
    case add
    case insert
  }
  
  typealias PutInfo = (frame: LocalizationFrame,
                       action: PutAction,
                       index: Int)
}
