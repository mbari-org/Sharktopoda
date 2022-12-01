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
  
  let nsTimeSliderView = NSTimeSliderView()
  
  func makeNSView(context: Context) -> NSView {
    nsTimeSliderView.windowData = windowData
    windowData.sliderView = nsTimeSliderView
    return nsTimeSliderView
  }
  
  func updateNSView(_ nsView: NSViewType, context: Context) {}
}
