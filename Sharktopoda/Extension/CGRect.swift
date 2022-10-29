//
//  CGRect.swift
//  Created for Sharktopoda on 10/28/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import CoreGraphics

extension CGRect {
  
  enum Location {
    case middle
    
    case left
    case top
    case right
    case bottom
    
    case topLeft
    case topRight
    case bottomRight
    case bottomLeft
    
    case outside
  }
  
  func location(of point: CGPoint) -> Location {
    guard contains(point) else { return .outside }
    
    let quarter = 0.25
    let half = 0.5
    
    let halfWidth = half * width
    let halfHeight = half * height
    
    let leftX = quarter * width
    let bottomY = quarter * height
    
    /// Middle
    if CGRect(x: leftX, y: bottomY, width: halfWidth, height: halfHeight).contains(point) {
      return .middle
    }
    
    let rightX = leftX + halfWidth
    let topY = bottomY + halfHeight
    let quarterHeight = quarter * height
    
    /// Top
    if CGRect(x: leftX, y: topY,
              width: halfWidth, height: quarterHeight).contains(point) {
      return .top
    }
    
    let quarterWidth = quarter * width
    
    /// Right
    if CGRect(x: rightX, y: bottomY,
              width: quarterWidth, height: halfHeight).contains(point) {
      return .right
    }
    
    /// Bottom
    if CGRect(x: leftX, y: 0,
              width: halfWidth, height: quarterHeight).contains(point) {
      return .bottom
    }
    
    /// Left
    if CGRect(x: 0, y: quarterHeight,
              width: quarterWidth, height: halfHeight).contains(point) {
      return .left
    }
    
    let threeQuarterHeight = quarterHeight + halfHeight
    
    /// TopLeft
    if CGRect(x: 0, y: threeQuarterHeight,
              width: quarterWidth, height: quarterHeight).contains(point) {
      return .topLeft
    }
    
    let threeQuarterWidth = quarterWidth + halfWidth
    
    /// TopRight
    if CGRect(x: threeQuarterWidth, y: threeQuarterHeight,
              width: quarterWidth, height: quarterHeight).contains(point) {
      return .topRight
    }
    
    /// BottomRight
    if CGRect(x: threeQuarterWidth, y: 0,
              width: quarterWidth, height: quarterHeight).contains(point) {
      return .bottomRight
    }
    
    /// BottomLeft
    if CGRect(x: 0, y: 0, width: quarterWidth,
              height: quarterHeight).contains(point) {
      return .bottomLeft
    }

    return .outside
  }
  
  func minSideDistance(point: CGPoint) -> CGFloat {
    guard contains(point) else { return CGFloat.infinity }
    
    let x = point.x
    let y = point.y
    
    let x0 = origin.x
    let y0 = origin.y
    let x1 = x0 + size.width
    let y1 = y0 + size.height
    
    return min(min(x-x0, x1-x), min(y-y0, y1-y))
  }

  func adjust(by delta: CGDelta) -> CGRect {
    CGRect(origin: origin.move(by: delta), size: size.adjust(by: delta))
  }

  func move(by delta: CGDelta) -> CGRect {
    CGRect(origin: origin.move(by: delta), size: size)
  }
  
  func resize(by delta: CGDelta) -> CGRect {
    CGRect(origin: origin, size: size.adjust(by: delta))
  }

}
