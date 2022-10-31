//
//  VPVMouse.swift
//  Created for Sharktopoda on 10/31/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit

extension VideoPlayerView {
  override func mouseDown(with event: NSEvent) {
    let mousePoint = event.locationInWindow
    
    if let mouseLayer = editLayer {
      let layerPoint = mouseLayer.convertSuperPoint(mousePoint)
      if mouseLayer.contains(layerPoint) {
        editLocation = mouseLayer.location(of: layerPoint)
        print("mouse down edit location: \(String(describing: editLocation))")
        return
      }
    }
    
    guard let mouseLayer = mouseLayer(point: mousePoint) else {
      editLayer = nil
      return
    }
    
    editLayer = mouseLayer
    let layerPoint = editLayer!.convertSuperPoint(mousePoint)
    editLocation = mouseLayer.location(of: layerPoint)
    print("mouse down edit location: \(String(describing: editLocation))")
    
    let _ = localizations!.select(id: editLayer!.localization!.id)
  }
  
  override func mouseDragged(with event: NSEvent) {
    guard let layer = editLayer else { return }
    
    /// Mouse delta is in ocean coords, flip to atmos
    let delta = DeltaPoint(x: event.deltaX, y: event.deltaY)
    
    print("mouse dragged edit location: \(editLocation ?? .outside)")
    print("delta: \(delta)")
    
    switch editLocation {
        /// deltaRect arguments should all be -1, 0, or 1
      case .middle:
        /// Move
        layer.delta(by: deltaRect(1, -1, 0, 0, delta: delta))
      case .top:
        /// Resize
        layer.delta(by: deltaRect(0, 0, 0, -1, delta: delta))
      case .topRight:
        /// Resize
        layer.delta(by: deltaRect(0, 0, 1, -1, delta: delta))
      case .right:
        /// Resize
        layer.delta(by: deltaRect(0, 0, 1, 0, delta: delta))
      case .bottomRight:
        /// Move and resize
        layer.delta(by: deltaRect(0, -1, 1, 1, delta: delta))
      case .bottom:
        /// Move and resize
        layer.delta(by: deltaRect(0, -1, 0, 1, delta: delta))
      case .bottomLeft:
        /// Move and resize
        layer.delta(by: deltaRect(1, -1, -1, 1, delta: delta))
      case .left:
        /// Move and resize
        layer.delta(by: deltaRect(1, 0, -1, 0, delta: delta))
      case .topLeft:
        /// Move and resize
        layer.delta(by: deltaRect(1, 0, -1, -1, delta: delta))
      case .outside:
        return
      case .none:
        return
    }
  }
  
  override func mouseExited(with event: NSEvent) {
    guard editLocation != nil else { return }
    
    print("CxInc mouse exit cancel current changes?")
    
    editLayer = nil
  }
  
  override func mouseUp(with event: NSEvent) {
    guard editLocation != nil else { return }
    
    print("CxInc mouse up")
  }
  
  private func mouseLayer(point: NSPoint) -> LocalizationLayer? {
    guard paused else { return nil }
    guard displayLocalizations else { return nil }
    guard let layers = localizations?.layers(.paused, at: currentTime) else { return nil }
    guard !layers.isEmpty else { return nil }
    
    let mousedLayers = layers.filter {
      $0.containsSuperPoint(point)
    }
    guard !mousedLayers.isEmpty else { return nil }
    
    let layer = mousedLayers.min { a, b in
      let aDistance = a.bounds.minSideDistance(point: point)
      let bDistance = b.bounds.minSideDistance(point: point)
      return aDistance < bDistance
    }!
    
    return layer
  }
  
  /// CxNote x, y, w, h should all be -1, 0, or 1
  private func deltaPoint(_ x: CGFloat, _ y: CGFloat, delta: CGPoint) -> DeltaPoint {
    DeltaPoint(x: x * delta.x, y: y * delta.y)
  }
  
  private func deltaSize(_ w: CGFloat, _ h: CGFloat, delta: CGPoint) -> DeltaSize {
    DeltaSize(width: w * delta.x, height: h * delta.y)
  }
  
  private func deltaRect(_ x: CGFloat, _ y: CGFloat,
                         _ w: CGFloat, _ h: CGFloat,
                         delta: CGPoint) -> DeltaRect {
    DeltaRect(origin: deltaPoint(x, y, delta: delta),
              size: deltaSize(w, h, delta: delta))
  }
}
