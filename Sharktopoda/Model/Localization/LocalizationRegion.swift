//
//  LocalizationRegion.swift
//  Created for Sharktopoda on 11/22/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

extension Localization {
  func reframe(to frame: CGRect) {
    CALayer.noAnimation {
      layer.shapeFrame(frame)
    }
  }
  
  func reframe(by delta: DeltaRect) {
    guard delta != .zero else { return }
    
    CALayer.noAnimation {
      layer.position = layer.position.move(by: delta.origin)
      layer.boundsResize(by: delta.size)
      layer.setNeedsLayout()
    }
  }
  
  private func delta(by delta: DeltaRect) {
    move(by: delta.origin)
    resize(by: delta.size)
  }
  
  private func move(by delta: DeltaPoint) {
    guard delta != .zero else { return }
    
    region = region.move(by: delta)
    
    CALayer.noAnimation {
      layer.position = layer.position.move(by: delta)
    }
  }
  
  private func resize(by delta: DeltaSize) {
    guard delta != .zero else { return }
    
    region = region.resize(by: delta)
    
    CALayer.noAnimation {
      layer.boundsResize(by: delta)
      layer.setNeedsLayout()
    }
  }
  
  func resize(for videoRect: CGRect) {
    CALayer.noAnimation {
      layer.shapeFrame(frame(for: videoRect))
      positionConceptLayer(for: videoRect)
    }
  }
}
