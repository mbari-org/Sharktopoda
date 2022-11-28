//
//  LocalizationSet.swift
//  Created for Sharktopoda on 10/6/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import SwiftUI

class Localizations {
  var storage = [String: Localization]()
  
  var pauseFrames = [LocalizationFrame]()
  var forwardFrames = [LocalizationFrame]()
  var reverseFrames = [LocalizationFrame]()
  
  var selected = Set<String>()

  let id: String
  let frameDuration: Int
  
  init(id: String, frameDuration: Int) {
    self.id = id
    self.frameDuration = frameDuration
  }
}

// MARK: Enums
extension Localizations {
  enum PutAction {
    case add
    case insert
  }
  
  typealias PutInfo = (frame: LocalizationFrame,
                       action: PutAction,
                       index: Int)
}

// MARK: Resize all
extension Localizations {
  func resize(for videoRect: CGRect) {
    for localization in storage.values {
      localization.resize(for: videoRect)
    }
  }
}
