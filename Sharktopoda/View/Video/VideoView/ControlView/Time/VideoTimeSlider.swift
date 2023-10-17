//
//  VideoTimeSlider
//  Created for Sharktopoda on 11/29/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import SwiftUI

struct VideoTimeSlider: NSViewRepresentable {
  @EnvironmentObject private var windowData: WindowData
  
  let nsTimeSlider = NSTimeSlider()
  
  func makeNSView(context: Context) -> NSView {
    nsTimeSlider.windowData = windowData
    windowData.timeSlider = nsTimeSlider
    return nsTimeSlider
  }
  
  func updateNSView(_ nsView: NSViewType, context: Context) {}
}
