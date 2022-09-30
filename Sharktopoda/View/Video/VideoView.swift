//
//  VideoView.swift
//  Created for Sharktopoda on 9/29/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI
import AVKit

struct VideoView: View {
  let videoAsset: VideoAsset
  let avPlayer: AVPlayer
  let videoPlayerView: VideoPlayerView
  
  init(videoAsset: VideoAsset) {
    self.videoAsset = videoAsset
    
    avPlayer = AVPlayer(url: videoAsset.url)
    videoPlayerView = VideoPlayerView(for: avPlayer)
    videoPlayerView.avPlayerView.controlsStyle = .inline
  }
  
  var body: some View {
    videoPlayerView
    // CxTBD This   could hold a custom control panel w/ .inline changed to .none
  }
}

extension VideoView {
  func fullSize() -> NSSize {
    let videoSize = self.videoAsset.size ?? NSMakeSize(600, 600)
    return NSMakeSize(videoSize.width, videoSize.height + 110)
  }
  
  var rate: Float {
    get {
      avPlayer.rate
    }
    set {
      avPlayer.rate = newValue
    }
  }
//  func rate() {
//    avPlayer.rate =
//  }
  
  func pause() {
    avPlayer.pause()
  }
}

//struct VideoView_Previews: PreviewProvider {
//  static var previews: some View {
//    VideoView()
//  }
//}
