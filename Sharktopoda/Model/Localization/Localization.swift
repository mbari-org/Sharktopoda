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
  var layer: CAShapeLayer
  var region: CGRect
  var fullSize: CGSize
  
  init(from controlLocalization: ControlLocalization, with fullSize: CGSize) {
    id = controlLocalization.uuid
    concept = controlLocalization.concept
    duration = controlLocalization.durationMillis
    elapsedTime = controlLocalization.elapsedTimeMillis
    hexColor = controlLocalization.color
    region = CGRect(x: CGFloat(controlLocalization.x),
                    y: CGFloat(controlLocalization.y),
                    width: CGFloat(controlLocalization.width),
                    height: CGFloat(controlLocalization.height))

    self.fullSize = fullSize

    let origin = CGPoint(x: region.minX,
                         y: fullSize.height - (region.minY + region.height))
    let layerFrame = CGRect(origin: origin, size: region.size)
    let cgColor = Color(hex: hexColor)?.cgColor
    layer = CAShapeLayer(frame: layerFrame, cgColor: cgColor!)
  }
  
  init(at elapsedTime: Int, with region: CGRect, layer: CAShapeLayer, fullSize: CGSize) {
    id = UUID().uuidString
    concept = UserDefaults.standard.string(forKey: PrefKeys.captionDefault)!
    duration = 0
    hexColor = UserDefaults.standard.hexColor(forKey: PrefKeys.displayBorderColor)

    self.elapsedTime = elapsedTime
    self.region = region
    self.fullSize = fullSize
    self.layer = layer
  }

  var debugDescription: String {
    "id: \(id), concept: \(concept), time: \(elapsedTime), duration: \(duration), color: \(hexColor)"
  }
}

// MARK: Modify region
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
                         y: fullSize.height - region.origin.y - region.size.height)
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
    let scale = videoRect.size.width / fullSize.width
    let videoHeight = videoRect.height / scale
    
    let size = CGSize(width: scale * region.size.width,
                      height: scale * region.size.height)
    
    let x = videoRect.origin.x + scale * region.origin.x
    let y = videoRect.origin.y + scale * (videoHeight - region.origin.y - region.size.height)
    let origin = CGPoint(x: x, y: y)
    
    return CGRect(origin: origin, size: size)
  }
}

