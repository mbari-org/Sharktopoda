//
//  CGRect.swift
//  Created for Sharktopoda on 10/28/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import CoreGraphics

typealias DeltaRect = CGRect

extension CGRect {
  enum Location {
    case middle
    case left, top, right, bottom
    case topLeft, topRight, bottomRight, bottomLeft
    case outside
  }
  
  func diagonal(of cornerPoint: CGPoint) -> CGPoint {
    let x = cornerPoint.x == minX ? maxX : minX
    let y = cornerPoint.y == minY ? maxY : minY
    return CGPoint(x: x, y: y)
  }

  func location(of point: CGPoint, corner: CGFloat = 0.2) -> Location {
    guard contains(point) else { return .outside }
    
    let cornerWidth = corner * size.width
    let cornerHeight = corner * size.height
    
    let stripWidth = size.width - 2.0 * cornerWidth
    let stripHeight = size.height - 2.0 * cornerHeight
    
    let cornerUpperLeft = CGPoint(x: minX + cornerWidth,
                                  y: maxY - cornerHeight)
    let cornerUpperRight = CGPoint(x: maxX - cornerWidth,
                                   y: maxY - cornerHeight)
    let cornerLowerRight = CGPoint(x: maxX - cornerWidth,
                                   y: minY + cornerHeight)
    let cornerLowerLeft = CGPoint(x: minX + cornerWidth,
                                  y: minY + cornerHeight)

    /// Middle
    if CGRect(origin: cornerLowerLeft,
              size: CGSize(width: stripWidth, height: stripHeight))
      .contains(point) { return .middle }

    let tallSize = CGSize(width: cornerWidth, height: stripHeight)
    let wideSize = CGSize(width: stripWidth, height: cornerHeight)

    /// Top
    if CGRect(origin: cornerUpperLeft, size: wideSize)
      .contains(point) { return .top }
    
    /// Right
    if CGRect(origin: cornerLowerRight, size: tallSize)
      .contains(point) { return .right }

    /// Bottom
    if CGRect(origin: CGPoint(x: cornerLowerLeft.x, y: minY), size: wideSize)
      .contains(point) { return .bottom }

    /// Left
    if CGRect(origin: CGPoint(x: minX, y: cornerLowerLeft.y), size: tallSize)
      .contains(point) { return .left }
    
    let cornerSize = CGSize(width: cornerWidth, height: cornerHeight)
    
    /// Top Left
    if CGRect(origin: CGPoint(x: minX, y: maxY - cornerHeight), size: cornerSize)
      .contains(point) { return .topLeft }

    /// Top Right
    if CGRect(origin: cornerUpperRight, size: cornerSize)
      .contains(point) { return .topRight }

    /// Bottom Right
    if CGRect(origin: CGPoint(x: cornerLowerRight.x, y: minY), size: cornerSize)
      .contains(point) { return .bottomRight }

    /// Bottom Left
    if CGRect(origin: origin, size: cornerSize)
      .contains(point) { return .bottomLeft }

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
    
    return min(x-x0, x1-x, y-y0, y1-y)
  }

  func move(by delta: DeltaPoint) -> CGRect {
    CGRect(origin: origin.move(by: delta), size: size)
  }
  
  
  func resize(by delta: DeltaSize) -> CGRect {
    CGRect(origin: origin, size: size.resize(by: delta))
  }

}
