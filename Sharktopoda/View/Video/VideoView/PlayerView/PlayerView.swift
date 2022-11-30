//
//  PlayerView.swift
//  Created for Sharktopoda on 10/31/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct PlayerView: NSViewRepresentable {
  @EnvironmentObject var windowData: WindowData
  
  let nsPlayerView = NSPlayerView()
  
  func makeNSView(context: Context) -> some NSView {
    nsPlayerView.windowData = windowData
    return nsPlayerView
  }
  
  func updateNSView(_ nsView: NSViewType, context: Context) {}
}
 
