//
//  NSTimeSlider
//  Created for Sharktopoda on 11/29/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit
import AVFoundation
import Combine
import SwiftUI

final class NSTimeSlider: NSView {
  // MARK: properties
  var _windowData: WindowData? = nil

  let markerLayer = CALayer()

  /// Hold current player direction during slider scrubbing
  var playerDirection: WindowData.PlayerDirection?

  var playerTimeSubscription: AnyCancellable?

  var windowData: WindowData {
    get { _windowData! }
    set { attach(windowData: newValue) }
  }

  func attach(windowData: WindowData) {
    _windowData = windowData

    frame = NSRect(x: 0, y: 0, width: windowData.videoAsset.fullSize.width, height: 40)

    wantsLayer = true

    addMarkerLayer()

    playerTimeSubscription = windowData.$playerTime
      .receive(on: DispatchQueue.main)
      .sink { [weak self] time in
        self?.updateMarkerPosition(for: time)
      }
  }

  var radius: CGFloat {
    NSHeight(bounds) / 2
  }

  override func draw(_ dirtyRect: NSRect) {
    NSColor.darkGray.set()
//    NSColor(red: 71, green: 64, blue: 61, alpha: 1.0).set()
    let horizontalLine = NSBezierPath()
    horizontalLine.move(to: NSMakePoint(0, radius))
    horizontalLine.line(to: NSMakePoint(frame.width, radius))
    horizontalLine.lineWidth = 4
    horizontalLine.stroke()  // draw line
  }

  private func addMarkerLayer() {
    markerLayer.frame = NSRect(x: 0, y: 0, width: radius, height: radius)
    markerLayer.cornerRadius = radius / 2
    markerLayer.backgroundColor = NSColor.systemGray.cgColor
    layer?.addSublayer(markerLayer)
  }

  func updateMarkerPosition(for time: CMTime) {
    let duration = windowData.videoAsset.duration.seconds
    guard duration > 0 else { return }

    let fraction = time.seconds / duration
    let halfWidth = markerLayer.bounds.width / 2
    let trackWidth = bounds.width - markerLayer.bounds.width
    let xPosition = halfWidth + CGFloat(fraction) * trackWidth

    CATransaction.begin()
    CATransaction.setDisableActions(true)
    markerLayer.position = CGPoint(x: xPosition, y: markerLayer.position.y)
    CATransaction.commit()
  }

  func setupControlViewAnimation() {
    updateMarkerPosition(for: windowData.videoControl.currentTime)
  }

}
