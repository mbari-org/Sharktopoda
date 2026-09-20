//
//  VideoView.swift
//  Created for Sharktopoda on 11/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import SwiftUI

struct VideoView: View {
  @EnvironmentObject var windowData: WindowData
  
  var body: some View {
    VStack {
      windowData.playerView
        .padding(0)

      VideoControlView()
        .environmentObject(windowData)
    }
    .padding(.bottom, 10)
  }
}
