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

    guard let layer = dragLayer,
          let anchor = dragAnchor else { return }
    
    let frameRect = anchor.diagonalRect(using: dragPoint)
    CALayer.noAnimation {
      layer.shapeFrame(frameRect)
    }
  }
  
  func endDragPurpose(at endPoint: CGPoint) {
    if let purpose = dragPurpose,
       let layer = dragLayer,
       let anchor = dragAnchor,
       let localizations = localizations {

      // CxTBD Parameterize min drag
      let totalDelta = anchor.delta(to: endPoint).abs()
      if 10 < totalDelta.x, 10 < totalDelta.y {
        switch purpose {
          case .create:
            let localization = Localization(at: currentTime, with: region(from: layer), layer: layer, fullSize: fullSize)
            let _ = localizations.add(localization)
            let _ = localizations.select(id: localization.id)
          case .select:
            /// Remove the selection layer as it's purpose is complete
            DispatchQueue.main.async {
              layer.removeFromSuperlayer()
            }
            localizations.select(using: layer.frame, at: currentTime)

            let message = ClientSelectLocalizations(videoId: videoAsset.id, ids: localizations.selectedIds())
            UDP.client.process(message)
        }
      }
    }

    dragLayer = nil
    dragPurpose = nil
  }
  
  private func shapeLayer(_ origin: CGPoint) -> CAShapeLayer {
    let hexColor = UserDefaults.standard.hexColor(forKey: PrefKeys.selectionBorderColor)
    let cgColor = Color(hex: hexColor)?.cgColor
    return CAShapeLayer(frame: .zero, cgColor: cgColor!)
  }
}
