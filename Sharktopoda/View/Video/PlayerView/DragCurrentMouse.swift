//
//  CurrentMouse.swift
//  Created for Sharktopoda on 11/8/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit

extension NSPlayerView {
  /// Drag the current selected Localization
  func dragCurrent(by delta: DeltaPoint) {
    guard delta != .zero else { return }
    
    switch dragAction(for: delta) {
      case .adjust:
        adjust(by: delta)
      case .flip(let flipData):
        flip(using: flipData)
      case .none:
        return
    }
  }
  
  private func dragAction(for mouseDelta: DeltaPoint) -> DragAction {
    guard let location = currentLocation else { return .none }
    guard let frame = currentFrame else { return .none }
    
    var flipData: FlipData
    
    switch location {
        
      case .middle:
        return .adjust
        
      case .top:
        dragAnchor = frame.origin
        let frameDelta = DeltaPoint(x: 0, y: -mouseDelta.y)
        flipData = deltaFlip(.I, frameDelta)
        
      case .topRight:
        dragAnchor = frame.origin
        let frameDelta = DeltaPoint(x: mouseDelta.x, y: -mouseDelta.y)
        flipData = deltaFlip(.I, frameDelta)
        
      case .right:
        dragAnchor = frame.origin
        let frameDelta = DeltaPoint(x: mouseDelta.x, y: 0)
        flipData = deltaFlip(.I, frameDelta)
        
      case .bottomRight:
        dragAnchor = CGPoint(x: frame.minX, y: frame.maxY)
        let frameDelta = DeltaPoint(x: mouseDelta.x, y: -mouseDelta.y)
        flipData = deltaFlip(.IV, frameDelta)
        
      case .bottom:
        dragAnchor = CGPoint(x: frame.minX, y: frame.maxY)
        let frameDelta = DeltaPoint(x: 0, y: -mouseDelta.y)
        flipData = deltaFlip(.IV, frameDelta)
        
      case .bottomLeft:
        dragAnchor = CGPoint(x: frame.maxX, y: frame.maxY)
        let frameDelta = DeltaPoint(x: mouseDelta.x, y: -mouseDelta.y)
        flipData = deltaFlip(.III, frameDelta)
        
      case .left:
        dragAnchor = CGPoint(x: frame.maxX, y: frame.minY)
        let frameDelta = DeltaPoint(x: mouseDelta.x, y: 0)
        flipData = deltaFlip(.II, frameDelta)
        
      case .topLeft:
        dragAnchor = CGPoint(x: frame.maxX, y: frame.minY)
        let frameDelta = DeltaPoint(x: mouseDelta.x, y: -mouseDelta.y)
        flipData = deltaFlip(.II, frameDelta)
        
      case .outside:
        return .none
    }
    
    return flipData.from == flipData.to ? .adjust : .flip(flipData)
  }
  
  /// Drag localiztion by delta inside same quadrant
  private func adjust(by delta: DeltaPoint) {
    guard let localization = currentLocalization else { return }
    guard let location = currentLocation else { return }
    
    /// CxNote deltaRect arguments should all be -1, 0, or 1
    switch location {
      case .middle:
        /// Move
        localization.delta(by: deltaRect(1, -1, 0, 0, delta: delta))
      case .top:
        /// Resize
        localization.delta(by: deltaRect(0, 0, 0, -1, delta: delta))
      case .topRight:
        /// Resize
        localization.delta(by: deltaRect(0, 0, 1, -1, delta: delta))
      case .right:
        /// Resize
        localization.delta(by: deltaRect(0, 0, 1, 0, delta: delta))
      case .bottomRight:
        /// Move and resize
        localization.delta(by: deltaRect(0, -1, 1, 1, delta: delta))
      case .bottom:
        /// Move and resize
        localization.delta(by: deltaRect(0, -1, 0, 1, delta: delta))
      case .bottomLeft:
        /// Move and resize
        localization.delta(by: deltaRect(1, -1, -1, 1, delta: delta))
      case .left:
        /// Move and resize
        localization.delta(by: deltaRect(1, 0, -1, 0, delta: delta))
      case .topLeft:
        /// Move and resize
        localization.delta(by: deltaRect(1, 0, -1, -1, delta: delta))
      case .outside:
        return
    }
    currentFrame = localization.layer.frame
  }
  
  private func flip(using flipData: FlipData) {
    guard let localization = currentLocalization else { return }
    guard let frame = currentFrame else { return }
    guard let location = currentLocation else { return }
    
    var origin: CGPoint
    var size: CGSize
    
    let (from, to, diagonal) = flipData
    
    switch from {
      case .I:
        switch to {
          case .I:
            return
            
          case .II:
            origin = CGPoint(x: diagonal.x, y: frame.minY)
            size = CGSize(width: frame.minX - diagonal.x,
                          height: diagonal.y - frame.minY)
            currentLocation = location == .right ? .left : .topLeft
            
          case .III:
            origin = CGPoint(x: diagonal.x, y: diagonal.y)
            size = CGSize(width: frame.minX - diagonal.x,
                          height: frame.minY - diagonal.y)
            currentLocation = .bottomLeft
            
          case .IV:
            origin = CGPoint(x: frame.minX, y: diagonal.y)
            size = CGSize(width: diagonal.x - frame.minX,
                          height: frame.minY - diagonal.y)
            currentLocation = location == .top ? .bottom : .bottomRight
        }
        
      case .II:
        switch to {
          case .I:
            origin = CGPoint(x: frame.maxX, y: frame.minY)
            size = CGSize(width: diagonal.x - frame.maxX,
                          height: diagonal.y - frame.minY)
            currentLocation = location == .left ? .right : .topRight
            
          case .II:
            return
            
          case .III:
            origin = CGPoint(x: diagonal.x, y: diagonal.y)
            size = CGSize(width: frame.maxX - diagonal.x,
                          height: frame.minY - diagonal.y)
            currentLocation = .bottomLeft
            
          case .IV:
            origin = CGPoint(x: frame.maxX, y: frame.minY)
            size = CGSize(width: diagonal.x - frame.maxX,
                          height: diagonal.y - frame.minX)
            currentLocation = .bottomRight
        }
        
      case .III:
        switch to {
          case .I:
            origin = CGPoint(x: frame.maxX, y: frame.maxY)
            size = CGSize(width: diagonal.x - frame.maxX,
                          height: diagonal.y - frame.maxY)
            currentLocation = .topRight
            
          case .II:
            origin = CGPoint(x: diagonal.x, y: frame.minY )
            size = CGSize(width: frame.maxX - diagonal.x,
                          height: diagonal.y - frame.minY)
            currentLocation = .topLeft
            
          case .III:
            return
            
          case .IV:
            origin = CGPoint(x: frame.maxX, y: frame.minY)
            size = CGSize(width: diagonal.x - frame.maxX,
                          height: frame.maxY - diagonal.y)
            currentLocation = .bottomRight
        }
        
      case .IV:
        switch to {
          case .I:
            origin = CGPoint(x: frame.minX,
                             y: frame.maxY)
            size = CGSize(width: frame.width,
                          height: diagonal.y - frame.minY)
            currentLocation = location == .bottom ? .top : .topRight
            
          case .II:
            origin = CGPoint(x: frame.minX, y: frame.maxY)
            size = CGSize(width: frame.minX - diagonal.x,
                          height: diagonal.y - frame.maxY)
            currentLocation = .topLeft
            
          case .III:
            origin = CGPoint(x: diagonal.x, y: frame.minY)
            size = CGSize(width: frame.minX - diagonal.x,
                          height: frame.maxY - diagonal.y)
            currentLocation = .bottomLeft
            
          case .IV:
            return
        }
    }
    localization.reframe(CGRect(origin: origin, size: size))
    self.currentFrame = localization.layer.frame
  }
  
  /// CxNote x, y, w, h should all be -1, 0, or 1
  private func deltaPoint(_ x: CGFloat, _ y: CGFloat, delta: DeltaPoint) -> DeltaPoint {
    DeltaPoint(x: x * delta.x, y: y * delta.y)
  }
  
  private func deltaSize(_ w: CGFloat, _ h: CGFloat, delta: DeltaPoint) -> DeltaSize {
    DeltaSize(width: w * delta.x, height: h * delta.y)
  }
  
  private func deltaRect(_ x: CGFloat, _ y: CGFloat,
                         _ w: CGFloat, _ h: CGFloat,
                         delta: CGPoint) -> DeltaRect {
    DeltaRect(origin: deltaPoint(x, y, delta: delta),
              size: deltaSize(w, h, delta: delta))
  }
  
  typealias FlipData = (from: CGPoint.Quadrant, to: CGPoint.Quadrant, diagonal: CGPoint)
  
  enum DragAction {
    case adjust
    case flip(_ using: FlipData)
    case none
  }
  
  private func deltaFlip(_ from: CGPoint.Quadrant, _ delta: DeltaPoint) -> FlipData {
    let diagonal = currentFrame!.diagonal(of: dragAnchor!)
    let deltaDiagonal = diagonal.move(by: delta)
    return (from, dragAnchor!.quadrant(of: deltaDiagonal), deltaDiagonal)
  }

}
