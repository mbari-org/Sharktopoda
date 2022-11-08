//
//  Localization.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import SwiftUI

class Localization {
  let id: String

  var concept: String
  var duration: Int
  var elapsedTime: Int
  var hexColor: String
  var region: CGRect
  
  var videoSize: CGSize

  var layer: CAShapeLayer
  
  init(from controlLocalization: ControlLocalization, with videoSize: CGSize) {
    id = controlLocalization.uuid
    concept = controlLocalization.concept
    duration = controlLocalization.durationMillis
    elapsedTime = controlLocalization.elapsedTimeMillis
    hexColor = controlLocalization.color
    region = CGRect(x: CGFloat(controlLocalization.x),
                    y: CGFloat(controlLocalization.y),
                    width: CGFloat(controlLocalization.width),
                    height: CGFloat(controlLocalization.height))

    self.videoSize = videoSize
    let origin = CGPoint(x: region.origin.x,
                         y: videoSize.height - region.origin.y - region.size.height)

    layer = CAShapeLayer()
    layer.anchorPoint = .zero
    layer.fillColor = .clear
    layer.isOpaque = true
    layer.lineJoin = .round
    layer.lineWidth = CGFloat(UserDefaults.standard.integer(forKey: PrefKeys.displayBorderSize))
    layer.strokeColor = Color(hex: hexColor)?.cgColor

    layer.shapeFrame(CGRect(origin: origin, size: region.size))

    // CxTBD Investigate
    layer.shouldRasterize = true
  }

  var debugDescription: String {
    "id: \(id), concept: \(concept), time: \(elapsedTime), duration: \(duration), color: \(hexColor)"
  }
}

// MARK: Modify region
extension Localization {
  func reframe(_ frame: CGRect) {
    CALayer.noAnimation {
      layer.shapeFrame(frame)
    }
  }
  
  func delta(by delta: DeltaRect) {
    move(by: delta.origin)
    resize(by: delta.size)
  }

  func move(by delta: DeltaPoint) {
    guard delta != .zero else { return }

    region = region.move(by: delta)
    
    CALayer.noAnimation {
      layer.position = layer.position.move(by: delta)
    }
  }
  
  func resize(by delta: DeltaSize) {
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
    }
  }
}

// MARK: Update
extension Localization {
  typealias TimelessUpdate = Bool
  
  func sameTime(as control: ControlLocalization) -> Bool {
    control.elapsedTimeMillis == elapsedTime && control.durationMillis == duration
  }
  
  func update(using control: ControlLocalization) {
    guard id == control.uuid else { return }

    concept = control.concept
    duration = control.durationMillis
    elapsedTime = control.elapsedTimeMillis
    hexColor = control.color
    region = CGRect(x: CGFloat(control.x),
                    y: CGFloat(control.y),
                    width: CGFloat(control.width),
                    height: CGFloat(control.height))
    
    layer.strokeColor = Color(hex: hexColor)?.cgColor

    let origin = CGPoint(x: region.origin.x,
                         y: videoSize.height - region.origin.y - region.size.height)
    CALayer.noAnimation {
      layer.shapeFrame(origin: origin, size: region.size)
    }
  }
}

// MARK: Select
extension Localization {
  func select(_ isSelected: Bool) {
    layer.strokeColor = isSelected
    ? UserDefaults.standard.color(forKey: PrefKeys.selectionBorderColor).cgColor
    : Color(hex: hexColor)?.cgColor
  }
}

// MARK: Hashable
extension Localization: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
    
  static func == (lhs: Localization, rhs: Localization) -> Bool {
    lhs.id == rhs.id
  }
}

// MARK: Shape Layer
extension Localization {
  private func frame(for videoRect: CGRect) -> CGRect {
    let scale = videoRect.size.width / videoSize.width
    let fullHeight = videoRect.height / scale
    
    let size = CGSize(width: scale * region.size.width,
                      height: scale * region.size.height)
    
    let x = videoRect.origin.x + scale * region.origin.x
    let y = videoRect.origin.y + scale * (fullHeight - region.origin.y - region.size.height)
    let origin = CGPoint(x: x, y: y)
    
    return CGRect(origin: origin, size: size)
  }
}

