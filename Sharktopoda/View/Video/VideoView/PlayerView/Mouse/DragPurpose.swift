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
    
    localizationData.clearSelected()
    currentLocalization = nil
    
    dragLayer = shapeLayer(purpose: purpose)
    playerLayer.addSublayer(dragLayer!)
  }
  
  func dragPurpose(using dragPoint: CGPoint) {
    guard dragPurpose != nil else { return }

    guard let dragLayer = dragLayer,
          let dragAnchor = dragAnchor else { return }
    
    let frameRect = dragAnchor.diagonalRect(using: dragPoint)
    CALayer.noAnimation {
      dragLayer.shapeFrame(frameRect)
    }
  }
  
  func endDragPurpose(at endPoint: CGPoint) {
    if let purpose = dragPurpose,
       let dragLayer = dragLayer,
       let anchor = dragAnchor {

      // CxTBD Parameterize min drag
      let totalDelta = anchor.delta(to: endPoint).abs()
      if 10 < totalDelta.x, 10 < totalDelta.y {
        switch purpose {
          case .create:
            let localization = Localization(at: currentTime,
                                            with: region(from: dragLayer),
                                            layer: dragLayer,
                                            fullSize: fullSize)
            localization.positionConceptLayer(for: videoRect)
            playerLayer.addSublayer(localization.conceptLayer)

            localizationData.add(localization)
            localizationData.sendLocalizationsMessage(.addLocalizations, localization: localization)
            localizationData.select(ids: [localization.id])
            
          case .select:
            /// Remove the selection layer as it's purpose is complete
            dragLayer.removeFromSuperlayer()
            
            localizationData.select(using: dragLayer.frame, at: currentTime)
        }
      } else {
        dragLayer.removeFromSuperlayer()
      }
    }

    dragLayer = nil
    dragPurpose = nil
  }
  
  private func shapeLayer(purpose: DragPurpose) -> CAShapeLayer {
    let colorKey = purpose == .create ? PrefKeys.creationBorderColor : PrefKeys.selectionBorderColor
    let hexColor = UserDefaults.standard.hexColor(forKey: colorKey)
    let borderColor = Color(hex: hexColor)?.cgColor

    let sizeKey = purpose == .create ? PrefKeys.creationBorderSize : PrefKeys.selectionBorderSize
    let borderSize = UserDefaults.standard.integer(forKey: sizeKey)
    
    return CAShapeLayer(frame: .zero, borderColor: borderColor!, borderSize: borderSize)
  }
}
