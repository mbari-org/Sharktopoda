//
//  DragLayer.swift
//  Created for Sharktopoda on 11/8/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit
import SwiftUI

extension NSPlayerView {
  
  enum DragPurpose {
    case create
    case select
  }
 
  func startDragPurpose(_ purpose: DragPurpose) {
    guard let anchor = dragAnchor else { return }
    dragPurpose = purpose
    
    localizations?.clearSelected()
    currentLocalization = nil
    
    let layer = shapeLayer(anchor)
    playerLayer.addSublayer(layer)
    
    dragLayer = layer
  }
  
  func dragPurpose(using dragPoint: CGPoint) {
    guard dragPurpose != nil else { return }

    guard let layer = dragLayer else { return }
    guard let anchor = dragAnchor else { return }
    
    let frameRect = anchor.diagonalRect(using: dragPoint)
    CALayer.noAnimation {
      layer.shapeFrame(frameRect)
    }
  }
  
  func endDragPurpose() {
    dragAnchor = nil
    
    if let purpose = dragPurpose,
       let layer = dragLayer {

      // CxTBD Parameterize min size
      guard (10 < layer.frame.width || 10 < layer.frame.height) else { return }
      
      switch purpose {
        case .create:
          localizations?.create(using: layer, at: currentTime, with: fullSize)
        case .select:
          localizations?.select(using: layer.frame, at: currentTime)
          /// Remove the selection layer as it's purpose is complet
          layer.removeFromSuperlayer()
      }
    }

    self.dragLayer = nil
    self.dragPurpose = nil
  }
  
  private func shapeLayer(_ origin: CGPoint) -> CAShapeLayer {
    let hexColor = UserDefaults.standard.hexColor(forKey: PrefKeys.selectionBorderColor)
    let cgColor = Color(hex: hexColor)?.cgColor
    return CAShapeLayer(frame: .zero, cgColor: cgColor!)
  }
}
