//
//  CAShapeLayer.swift
//  Created for Sharktopoda on 10/28/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

extension CAShapeLayer {
  func boundsPath() {
    path = CGPath(rect: CGRect(origin: .zero, size: bounds.size), transform: nil)
  }
  
  func boundsResize(by size: DeltaSize) {
    bounds = bounds.resize(by: size)
    print("bounds: \(bounds)")
    boundsPath()
  }
  
  func shapeFrame(_ frame: CGRect) {
    self.frame = frame
    boundsPath()
  }
  
  func shapeFrame(origin: CGPoint, size: CGSize) {
    shapeFrame(CGRect(origin: origin, size: size))
  }
  
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
