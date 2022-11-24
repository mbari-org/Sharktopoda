//
//  VideoView.swift
//  Created for Sharktopoda on 11/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import SwiftUI

struct VideoView: View {
  let localizations: Localizations
  let videoControl: VideoControl
  
  var playerView: PlayerView
  
  init(localizations: Localizations,
       videoControl: VideoControl) {
    self.localizations = localizations
    self.videoControl = videoControl

    playerView = PlayerView(id: videoControl.id,
                            localizations: localizations,
                            videoControl: videoControl)
  }

  var body: some View {
    VStack {
      playerView
        .padding(0)
      Divider()
      VideoControlView()
        .environmentObject(videoControl)
        .padding(0)
    }
  }
}

//struct VideoView_Previews: PreviewProvider {
//  static var previews: some View {
////    VideoView(id: "CxDebug").environmentObject(SharktopodaData())
//    VideoView(VideoAsset(), videoId: "CxDebug")
//  }
//}
