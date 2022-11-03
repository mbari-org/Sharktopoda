//
//  DragSelectMouse.swift
//  Created for Sharktopoda on 11/2/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit

extension NSPlayerView {
  func startDragSelect(_ mousePoint: CGPoint) {
    localizations?.clearSelected()
    
    dragAnchorPoint = mousePoint
    
    let layer = CAShapeLayer()
    layer.anchorPoint = .zero
    layer.fillColor = .clear
    layer.isOpaque = true
    layer.lineWidth = 1.0
    layer.strokeColor = UserDefaults.standard.color(forKey: PrefKeys.selectionBorderColor).cgColor
    layer.shapeFrame(origin: mousePoint, size: .zero)
    selectLayer = layer
    
    playerLayer.addSublayer(layer)
    
    currentLocalization = nil
  }
  
  func dragSelect(_ mousePoint: CGPoint) {
    guard let selectPoint = dragAnchorPoint else { return }
    guard let selectLayer = selectLayer else { return }

    let delta = selectPoint.delta(to: mousePoint)
    
    var origin: CGPoint
    switch selectPoint.quadrant(of: mousePoint) {
      case .qI:
        origin = selectPoint
      case .qII:
        origin = CGPoint(x: selectPoint.x + delta.x,
                         y: selectPoint.y)
      case .qIII:
        origin = CGPoint(x: selectPoint.x + delta.x,
                         y: selectPoint.y + delta.y)
      case .qIV:
        origin = CGPoint(x: selectPoint.x,
                         y: selectPoint.y + delta.y)
    }
    
    let absDelta = delta.abs()
    let size = DeltaSize(width: absDelta.x, height: absDelta.y)
    
    CALayer.noAnimation {
      selectLayer.shapeFrame(origin: origin, size: size)
    }
  }
  
  func endDragSelect() {
    guard let selectLayer = selectLayer else { return }
    
    /// Select the intersecting localizations
    localizations?.select(for: selectLayer.frame, at: currentTime)

    /// Remove the selection layer and clean up
    selectLayer.removeFromSuperlayer()
    self.dragAnchorPoint = nil
    self.selectLayer = nil
  }
}
