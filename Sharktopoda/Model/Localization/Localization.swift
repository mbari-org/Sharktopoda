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
  var elapsedTime: Int
  var duration: Int
  var region: CGRect
  var hexColor: String
  
  var layer: CAShapeLayer
  
  init(from controlLocalization: ControlLocalization) {
    id = controlLocalization.uuid
    concept = controlLocalization.concept
    elapsedTime = controlLocalization.elapsedTimeMillis
    duration = controlLocalization.durationMillis
    hexColor = controlLocalization.color
    
    region = CGRect(x: CGFloat(controlLocalization.x),
                    y: CGFloat(controlLocalization.y),
                    width: CGFloat(controlLocalization.width),
                    height: CGFloat(controlLocalization.height))
    
    layer = CAShapeLayer()
  }

  var debugDescription: String {
    "id: \(id), concept: \(concept), time: \(elapsedTime), duration: \(duration), color: \(hexColor)"
  }
}

// MARK: Adjust region
extension Localization {
  func delta(by delta: DeltaRect) {
    move(by: delta.origin)
    resize(by: delta.size)
  }

  func move(by delta: DeltaPoint) {
    guard delta != .zero else { return }

    region = region.move(by: delta)

    layer.position = layer.position.move(by: delta)
  }
  
  func resize(by delta: DeltaSize) {
    guard delta != .zero else { return }
    
    region = region.resize(by: delta)
    
    layer.bounds = layer.bounds.resize(by: delta)
    layer.path = layerPath()
    layer.setNeedsLayout()
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
    layer.path = layerPath()
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
  func setup(for videoRect: CGRect, at scale: CGFloat)  {
    layer.anchorPoint = .zero
    layer.fillColor = .clear
    layer.frame = frame(for: videoRect, at: scale)
    layer.isOpaque = true
    layer.lineJoin = .round
    layer.lineWidth = CGFloat(UserDefaults.standard.integer(forKey: PrefKeys.displayBorderSize))
    layer.path = layerPath()
    layer.strokeColor = Color(hex: hexColor)?.cgColor
  }
  
  func layerPath() -> CGPath {
    CGPath(rect: CGRect(origin: .zero, size: layer.bounds.size), transform: nil)
  }
  
  private func frame(for videoRect: CGRect, at scale: CGFloat) -> CGRect {
    let fullHeight = videoRect.height / scale
    
    let size = CGSize(width: scale * region.size.width,
                      height: scale * region.size.height)
    
    let x = videoRect.origin.x + scale * region.origin.x
    let y = videoRect.origin.y + scale * (fullHeight - region.origin.y - region.size.height)
    let origin = CGPoint(x: x, y: y)
    
    return CGRect(origin: origin, size: size)
  }
}

