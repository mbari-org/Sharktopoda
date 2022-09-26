//
//  VideoAsset.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct VideoAsset {
  var uuid: String
  var localizations: [Localization] = []
}

//extension VideoAsset: Hashable {
//  static func == (lhs: VideoAsset, rhs: VideoAsset) -> Bool {
//    lhs.uuid == rhs.uuid
//  }
//  
//  func hash(into hasher: inout Hasher) {
//    hasher.combine(uuid)
//  }
//}
