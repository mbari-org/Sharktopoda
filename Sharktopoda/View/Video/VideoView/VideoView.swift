//
//  VideoView.swift
//  Created for Sharktopoda on 11/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import SwiftUI

struct VideoView: View {
  var playerView: PlayerView
  
  init(localizations: Localizations,
       playerControl: PlayerControl) {

    playerView = PlayerView(id: playerControl.id,
                            localizations: localizations,
                            playerControl: playerControl)
  }

  var body: some View {
    VStack {
      playerView
        .padding(0)
      Divider()
      VideoControlView()
//        .environmentObject(videoAsset)
        .padding(0)
    }
  }
  
  var player: AVPlayer {
    playerView.player
  }

}

//struct VideoView_Previews: PreviewProvider {
//  static var previews: some View {
////    VideoView(id: "CxDebug").environmentObject(SharktopodaData())
//    VideoView(VideoAsset(), videoId: "CxDebug")
//  }
//}
