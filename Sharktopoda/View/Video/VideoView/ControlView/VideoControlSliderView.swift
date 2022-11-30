//
//  VideoControlSliderView.swift
//  Created for Sharktopoda on 11/29/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import SwiftUI

struct VideoControlSliderView: NSViewRepresentable {
  @EnvironmentObject private var windowData: WindowData
  
  let nsSliderView = NSSliderView()
  
  func makeNSView(context: Context) -> NSView {
    nsSliderView.windowData = windowData
    windowData.sliderView = nsSliderView
    return nsSliderView
  }
  
  func updateNSView(_ nsView: NSViewType, context: Context) {}
}
