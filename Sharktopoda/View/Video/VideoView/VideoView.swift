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
  var keyInfo: KeyInfo = KeyInfo()
  
  init(playerControl: PlayerControl,
       videoAsset: VideoAsset,
       sharktopodaData: SharktopodaData) {

    playerView = PlayerView(id: videoAsset.id,
                            playerControl: playerControl,
                            videoAsset: videoAsset,
                            sharktopodaData: sharktopodaData)
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
