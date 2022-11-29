//
//  VideoControlSliderView.swift
//  Created for Sharktopoda on 11/29/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import SwiftUI

struct VideoControlSliderView: NSViewRepresentable {
  private let nsView = NSView()
  
  var layer: CALayer? {
    nsView.layer
  }
  
  func makeNSView(context: Context) -> NSView {
    nsView
  }
  
  func updateNSView(_ nsView: NSViewType, context: Context) {}
  
}
