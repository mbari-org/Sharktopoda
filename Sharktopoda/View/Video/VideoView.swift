//
//  VideoView.swift
//  Created for Sharktopoda on 9/14/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI
import AVKit

struct VideoView: View {
  @State var player = AVPlayer()
  
  let videoAsset: VideoAsset
  
  //  override static var layerClass: AnyClass { AVPlayerLayer.self }
  
  init(videoAsset: VideoAsset) {
    self.videoAsset = videoAsset
  }
  
  var body: some View {
    VideoPlayer(player: player)
      .onAppear() {
        self.player = AVPlayer(url: self.videoAsset.url)
      }
  }
}

struct VideoView_Previews: PreviewProvider {
  static var previews: some View {
    VideoView(videoAsset: VideoAsset(uuid: "VideoAsset UUID", url: URL(string: "http://cxInc.com")!))
  }
}
