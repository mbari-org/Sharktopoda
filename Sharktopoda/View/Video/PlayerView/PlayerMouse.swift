//
//  VPVMouse.swift
//  Created for Sharktopoda on 10/31/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit

extension NSPlayerView {
  override func mouseDown(with event: NSEvent) {
    pause()
    
    let mousePoint = event.locationInWindow
    
    if event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command {
      commandSelect(mousePoint)
    } else if !clickedCurrentLocalization(mousePoint) {
      mouseSelect(mousePoint)
    }
//  } else if !currentLocalizationSelected(mousePoint) {
//      selectLocalization(mousePoint)
//    }
  }
  
  override func mouseDragged(with event: NSEvent) {
    if let localization = currentLocalization {
      /// Mouse delta is in ocean coords, flip to atmos
      let delta = DeltaPoint(x: event.deltaX, y: event.deltaY)
      dragLocalization(localization, delta: delta)
    }
    
    //    print("mouse dragged edit location: \(editLocation ?? .outside)")
    //    print("delta: \(delta)")
  }
  
  override func mouseExited(with event: NSEvent) {
    guard dragLocation != nil else { return }
    
    print("CxInc mouse exit cancel current changes?")
    
    dragLocation = nil
  }
  
  override func mouseUp(with event: NSEvent) {
    guard let editLocalization = currentLocalization else { return }
    
    print("CxInc mouse up for \(editLocalization)")
  }
}

extension NSPlayerView {
  private func startDragSelect(_ mousePoint: CGPoint) {
    let layer = CAShapeLayer()
    
    layer.anchorPoint = .zero
    layer.fillColor = .clear
    layer.frame = CGRect(origin: mousePoint, size: .zero)
    layer.isOpaque = true
    layer.lineWidth = 1.0
    layer.strokeColor = UserDefaults.standard.color(forKey: PrefKeys.selectionBorderColor).cgColor

    dragLayer = layer
  }
  
  private func deltaDragSelect(_ delta: DeltaPoint) {
    
  }
  
  private func endDragSelect(_ mousePoint: CGPoint) {
  }
}
