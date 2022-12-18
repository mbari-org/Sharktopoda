//
//  LocalizationMisc.swift
//  Created for Sharktopoda on 11/22/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

// MARK: Hashable
extension Localization: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: Localization, rhs: Localization) -> Bool {
    lhs.id == rhs.id
  }
}

extension Localization {
  func frame(for videoRect: CGRect) -> CGRect {
    let scale = videoRect.size.width / fullSize.width
    let videoHeight = videoRect.height / scale
    
    let size = CGSize(width: scale * region.size.width,
                      height: scale * region.size.height)
    
    let x = videoRect.origin.x + scale * region.origin.x
    let y = videoRect.origin.y + scale * (videoHeight - region.origin.y - region.size.height)
    let origin = CGPoint(x: x, y: y)
    
    return CGRect(origin: origin, size: size)
  }
}

