//
//  VPVMouse.swift
//  Created for Sharktopoda on 10/31/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit

extension NSPlayerView {
  override func mouseDown(with event: NSEvent) {
    let mousePoint = event.locationInWindow
    
//    if event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command,
    
    if let mouseLayer = editLocalization?.layer {
      let layerPoint = mouseLayer.convertSuperPoint(mousePoint)
      if mouseLayer.contains(layerPoint) {
        editLocation = mouseLayer.location(of: layerPoint)
        return
      }
    }
    
    guard let mouseLocalization = mouseLocalization(at: mousePoint) else {
      editLocalization = nil
      return
    }

    let _ = localizations?.select(id: mouseLocalization.id)
    
    let layer = mouseLocalization.layer
    let layerPoint = layer.convertSuperPoint(mousePoint)
    editLocalization = mouseLocalization
    editLocation = layer.location(of: layerPoint)
    
    print("location: \(String(describing: editLocation))")
    print("localization: \(String(describing: editLocalization))")
    
  }
  
  override func mouseDragged(with event: NSEvent) {
    guard let localization = editLocalization else { return }

    /// Mouse delta is in ocean coords, flip to atmos
    let delta = DeltaPoint(x: event.deltaX, y: event.deltaY)

//    print("mouse dragged edit location: \(editLocation ?? .outside)")
//    print("delta: \(delta)")

    switch editLocation {
        /// deltaRect arguments should all be -1, 0, or 1
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
      case .none:
        return
    }
  }
  
  override func mouseExited(with event: NSEvent) {
    guard editLocation != nil else { return }
    
    print("CxInc mouse exit cancel current changes?")
    
    editLocation = nil
  }
  
  override func mouseUp(with event: NSEvent) {
    guard let editLocalization = editLocalization else { return }

    print("CxInc mouse up for \(editLocalization)")
  }
  
  private func mouseLocalization(at point: NSPoint) -> Localization? {
    guard paused else { return nil }
    guard showLocalizations else { return nil }
    guard let pausedLocalizations = localizations?.fetch(.paused, at: currentTime) else { return nil }
    guard !pausedLocalizations.isEmpty else { return nil }
    
    let mousedLocalizations = pausedLocalizations.filter {
      $0.layer.containsSuperPoint(point)
    }
    guard !mousedLocalizations.isEmpty else { return nil }
    
    return mousedLocalizations.min { a, b in
      let aDistance = a.layer.bounds.minSideDistance(point: point)
      let bDistance = b.layer.bounds.minSideDistance(point: point)
      return aDistance < bDistance
    }!
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
