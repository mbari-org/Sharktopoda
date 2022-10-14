//
//  Localization.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

struct Localization: Hashable {
  let id: String
  let concept: String
  let elapsedTime: Int
  let duration: Int
  let region: CGRect
  let hexColor: String
  
  init(from controlLocalization: ControlLocalization, for asset: VideoAsset) {
    id = controlLocalization.uuid
    concept = controlLocalization.concept
    elapsedTime = controlLocalization.elapsedTimeMillis
    duration = controlLocalization.durationMillis
    hexColor = controlLocalization.color
    
    if let assetSize = asset.size {
      region = CGRect(x: CGFloat(controlLocalization.x) / assetSize.width,
                      y: 1.0 - (CGFloat(controlLocalization.y) / assetSize.height),
                      width: CGFloat(controlLocalization.width) / assetSize.width,
                      height: CGFloat(controlLocalization.height) / assetSize.height)
    } else {
      region = .zero
    }
  }

  // Hashable
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: Localization, rhs: Localization) -> Bool {
    lhs.id == rhs.id
  }
}

struct OrderedLocalization: Comparable {
  let id: String
  let elapsedTime: Int
  
  init(for localization: Localization) {
    id = localization.id
    elapsedTime = localization.elapsedTime
  }
  
  // Comparable
  static func < (lhs: OrderedLocalization, rhs: OrderedLocalization) -> Bool {
    lhs.elapsedTime < rhs.elapsedTime
  }
}
