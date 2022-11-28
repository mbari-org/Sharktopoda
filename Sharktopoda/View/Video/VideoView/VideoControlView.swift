//
//  VideoControlView.swift
//  Created for Sharktopoda on 11/18/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct VideoControlView: View {
  @EnvironmentObject var windowData: WindowData
  
  var videoControl: VideoControl {
    windowData.videoControl
  }
  
  var playerDirection: VideoControl.PlayerDirection {
    videoControl.playerDirection
  }
  
  var previousDirection: VideoControl.PlayerDirection {
    videoControl.previousDirection
  }
  
  var body: some View {
    HStack {
      Button(action: {
        guard playerDirection != .reverse else { return }
        previousDirection == .reverse ? videoControl.play() : videoControl.reverse()
      }) {
        Image(systemName: playerDirection == .reverse
              ? "arrowtriangle.backward.circle.fill"
              : "arrowtriangle.backward.circle")
      }
      .padding(.leading, 10)

      Button(action: {
        guard playerDirection != .paused else { return }
        videoControl.pause()
      }) {
        Image(systemName: videoControl.paused
              ? "pause.circle.fill"
              : "pause.circle")
      }

      Button(action: {
        guard playerDirection != .forward else { return }
        previousDirection == .forward ? videoControl.play() : videoControl.reverse()
      }) {
        Image(systemName: playerDirection == .reverse
              ? "play.circle.fill"
              : "play.circle")
      }
      .padding(.trailing, 10)
      
      Spacer()
      
      Text(String(videoControl.playerTime))
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
    .padding(.bottom, 10)
  }
}

//struct VideoControlView_Previews: PreviewProvider {
//  static var previews: some View {
//    VideoControlView().environmentObject(VideoControl())
//  }
//}
