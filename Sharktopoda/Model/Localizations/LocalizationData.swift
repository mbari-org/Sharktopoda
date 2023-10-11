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
  
  // CxTBD Initial implementation strategy maintained these forward and reverse frame indexes
  // in anticipation of need when displaying 10K+ video localizations. Subsequent development
  // indicates that using a "spanning" strategy actually works even under 10K+ loads.
  // However, they are not being removed (yet) pending further investigation.
  var forwardFrames = [LocalizationFrame]()
  var reverseFrames = [LocalizationFrame]()
  
  var selected = Set<String>()

  let videoAsset: VideoAsset

  var frameMillis: Int {
    videoAsset.frameDuration.asMillis()
  }
  
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

// MARK: Resize all non-paused Localizations
extension LocalizationData {
  
  func resize(for videoRect: CGRect) {
    for localization in storage.values {
      localization.resize(for: videoRect)
    }
  }
}
