//
//  VideoPlayView.swift
//  Created for Sharktopoda on 10/31/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import SwiftUI

struct VideoPlayerView: View {
  let videoAsset: VideoAsset
  let playerView: PlayerView
  
  init(videoAsset: VideoAsset) {
    self.videoAsset = videoAsset
    playerView = PlayerView(videoAsset: videoAsset)
  }
  
  var body: some View {
    VStack {
      playerView
        .padding(0)
      Divider()
      Text("Hidable Video Control")
        .padding(0)
    }
  }
}

//struct VideoPlayView_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoPlayView()
//    }
//}
