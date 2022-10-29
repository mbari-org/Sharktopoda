//
//  CGPoint.swift
//  Created for Sharktopoda on 10/28/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import CoreGraphics

typealias CGDelta = CGPoint

extension CGPoint {
  func move(by delta: CGDelta) -> CGPoint {
    CGPoint(x: x + delta.x, y: y + delta.y)
  }
}
