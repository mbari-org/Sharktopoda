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
  func canStep(_ steps: Int) -> Bool {
    guard let item = avPlayer.currentItem else {
      return false
    }
    return steps < 0 ? item.canStepBackward : item.canStepForward
  }
  
  func step(_ steps: Int) {
    avPlayer.currentItem?.step(byCount: steps)
  }
  
  func elapsed() -> Int {
    guard let currentTime = avPlayer.currentItem?.currentTime() else { return 0 }
    return Int(CMTimeGetSeconds(currentTime)) * VideoAsset.timescale
  }
  
  func fullSize() -> NSSize {
    let videoSize = self.videoAsset.size ?? NSMakeSize(600, 600)
    return NSMakeSize(videoSize.width, videoSize.height + 110)
  }

  func pause() {
    avPlayer.pause()
  }
  
  var rate: Float {
    get { avPlayer.rate }
    set { avPlayer.rate = newValue }
  }
  
  func seek(elapsed: Int) {
    avPlayer.seek(to: CMTimeMake(value: Int64(elapsed), timescale: Int32(VideoAsset.timescale)))
  }
}

//struct VideoView_Previews: PreviewProvider {
//  static var previews: some View {
//    VideoView()
//  }
//}
