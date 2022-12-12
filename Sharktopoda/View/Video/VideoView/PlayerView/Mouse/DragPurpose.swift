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
    
    localizations.clearSelected()
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
       let anchor = dragAnchor {

      // CxTBD Parameterize min drag
      let totalDelta = anchor.delta(to: endPoint).abs()
      if 10 < totalDelta.x, 10 < totalDelta.y {
        switch purpose {
          case .create:
            let localization = Localization(at: currentTime,
                                            with: region(from: layer),
                                            layer: layer,
                                            fullSize: fullSize)
            localizations.add(localization)
            localizations.sendLocalizationsMessage(.addLocalizations, ids: [localization.id])

            if localizations.select(id: localization.id),
               let conceptLayer = localization.conceptLayer {
              localization.positionConcept(for: videoRect)
              playerLayer.addSublayer(conceptLayer)
            }
            
            // CxTBD Is an updated selected message necessary?
            localizations.sendLocalizationsMessage(.selectLocalizations, ids: [localization.id])

          case .select:
            /// Remove the selection layer as it's purpose is complete
            DispatchQueue.main.async {
              layer.removeFromSuperlayer()
            }
            
            localizations.select(using: layer.frame, at: currentTime)
            localizations.selectedLocalizations.forEach {
              displayConcept(for: $0)
            }
        }
      } else {
        DispatchQueue.main.async {
          layer.removeFromSuperlayer()
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
