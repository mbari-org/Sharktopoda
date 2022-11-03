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
  
  func dragSelect(_ dragPoint: CGPoint) {
    guard let selectLayer = selectLayer else { return }
    guard let anchorPoint = dragAnchorPoint else { return }
    
    let frameRect = anchorPoint.diagonalRect(using: dragPoint)
    CALayer.noAnimation {
      selectLayer.shapeFrame(frameRect)
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
