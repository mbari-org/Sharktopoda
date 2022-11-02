//
//  CAShapeLayer.swift
//  Created for Sharktopoda on 10/28/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

extension CAShapeLayer {
  func containsSuperPoint(_ point: CGPoint) -> Bool {
    contains(convertSuperPoint(point))
  }
  
  func convertSuperPoint(_ point: CGPoint) -> CGPoint {
    convert(point, from: superlayer)
  }
  
  func location(of point: CGPoint) -> CGRect.Location {
    bounds.location(of: point)
  }
}
