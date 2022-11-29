//
//  VideoControlPlayButtons.swift
//  Created for Sharktopoda on 11/29/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct VideoControlPlayButtons: View {
  @EnvironmentObject var windowData: WindowData
  
  var playerDirection: WindowData.PlayerDirection {
    windowData.playerDirection
  }
  
  var previousDirection: WindowData.PlayerDirection {
    windowData.previousDirection
  }
  
  var body: some View {
    HStack {
      Button(action: {
        guard playerDirection != .reverse else { return }
        previousDirection == .reverse ? windowData.play() : windowData.reverse()
      }) {
        Image(systemName: playerDirection == .reverse
              ? "arrowtriangle.backward.circle.fill"
              : "arrowtriangle.backward.circle")
      }
      .padding(.leading, 10)
      
      Button(action: {
        guard playerDirection != .paused else { return }
        windowData.pause()
      }) {
        Image(systemName: playerDirection == .paused
              ? "pause.circle.fill"
              : "pause.circle")
      }
      
      Button(action: {
        guard playerDirection != .forward else { return }
        previousDirection == .forward ? windowData.play() : windowData.reverse()
      }) {
        Image(systemName: playerDirection == .forward
              ? "play.circle.fill"
              : "play.circle")
      }
      .padding(.trailing, 10)
    }
  }
}

struct VideoControlButtonsView_Previews: PreviewProvider {
  static var previews: some View {
    VideoControlPlayButtons()
  }
}
