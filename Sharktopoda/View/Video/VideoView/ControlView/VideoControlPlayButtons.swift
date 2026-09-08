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
    windowData.videoControl.previousDirection
  }
  
  var body: some View {
    HStack {
      
      Button(action: {
        guard playerDirection != .backward else { return }
        windowData.playBackward()
      }) {
        Image(systemName: playerDirection == .backward
              ? "arrowtriangle.backward.circle.fill"
              : "arrowtriangle.backward.circle")
          .foregroundColor(iconColor(for: .backward))
      }
      
      Button(action: {
        guard playerDirection != .paused else { return }
        windowData.pause()
      }) {
        Image(systemName: playerDirection == .paused
              ? "pause.circle.fill"
              : "pause.circle")
          .foregroundColor(iconColor(for: .paused))
      }
      .padding(.leading, 15)
      .padding(.trailing, 15)
      
      Button(action: {
        guard playerDirection != .forward else { return }
        windowData.playForward()
      }) {
        Image(systemName: playerDirection == .forward
              ? "play.circle.fill"
              : "play.circle")
          .foregroundColor(iconColor(for: .forward))
      }
    }
  }
  
  private func iconColor(for direction: WindowData.PlayerDirection) -> Color {
    playerDirection == direction ? .green : .blue
  }
}

struct VideoControlButtonsView_Previews: PreviewProvider {
  static var previews: some View {
    VideoControlPlayButtons()
  }
}
