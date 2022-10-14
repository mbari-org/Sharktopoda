//
//  FrameLocalization.swift
//  Created for Sharktopoda on 10/13/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct FrameLocalization: Comparable {
  let id: String
  let elapsedTime: Int
  
  init(using localization: Localization, for asset: VideoAsset) {
    id = localization.id
    elapsedTime = localization.elapsedTime
  }
  
  // Comparable
  static func < (lhs: FrameLocalization, rhs: FrameLocalization) -> Bool {
    lhs.elapsedTime < rhs.elapsedTime
  }
}
