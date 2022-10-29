//
//  CGSize.swift
//  Created for Sharktopoda on 10/29/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import CoreGraphics

extension CGSize {
  func adjust(by delta: CGDelta) -> CGSize {
    CGSize(width: width + delta.x, height: height + delta.y)
  }
}
