//
//  VideoControlView.swift
//  Created for Sharktopoda on 11/18/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct VideoControlView: View {
  @EnvironmentObject var playerControl: PlayerControl
  
  var body: some View {
    HStack {
      Button(action: {
        playerControl.paused ? playerControl.play() : playerControl.pause()
      }) {
        Image(systemName: playerControl.paused ? "play" : "pause")
      }
      .padding(.leading, 10)
      .padding(.trailing, 10)
      
      Spacer()
      
      Text(String(playerControl.playerTime))
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
    .padding(.bottom, 10)
  }
}

//struct VideoControlView_Previews: PreviewProvider {
//  static var previews: some View {
//    VideoControlView().environmentObject(PlayerControl())
//  }
//}
