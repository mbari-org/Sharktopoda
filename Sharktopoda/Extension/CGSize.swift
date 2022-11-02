//
//  CGSize.swift
//  Created for Sharktopoda on 10/29/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import CoreGraphics

typealias DeltaSize = CGSize

extension CGSize {
  func resize(by delta: DeltaSize) -> CGSize {
    CGSize(width: width + delta.width, height: height + delta.height)
  }
}
