//
//  VideoView.swift
//  Created for Sharktopoda on 9/29/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI
import AVKit
import AVFoundation
import UniformTypeIdentifiers

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
  
  func elapsed() -> Int {
    guard let currentTime = avPlayer.currentItem?.currentTime() else { return 0 }
    return currentTime.asMillis()
  }
  
  func frameGrab(at captureTime: Int, destination: URL) async -> (grabFrame: Int?, error: String?) {
    let frameTime = CMTime.fromMillis(captureTime)
    
    let asset = AVURLAsset(url: destination)
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    imageGenerator.requestedTimeToleranceAfter = CMTime.zero
    imageGenerator.requestedTimeToleranceBefore = CMTime.zero
    
    var grabTime: CMTime = .indefinite
    do {
      let cgImage = try imageGenerator.copyCGImage(at: frameTime, actualTime: &grabTime)
      
      let cfDestination: CFURL = destination as CFURL
      let cfPng: CFString = UTType.png as! CFString
      let cgDestination: CGImageDestination = CGImageDestinationCreateWithURL(cfDestination, cfPng, 1, nil)!
      
      CGImageDestinationAddImage(cgDestination, cgImage, nil);
      
      return(grabTime.asMillis(), nil)
    } catch {
      return (nil, "unable to grab image at time \(frameTime.asMillis()))")
    }
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
    avPlayer.seek(to: CMTime.fromMillis(elapsed))
  }
  
  func step(_ steps: Int) {
    avPlayer.currentItem?.step(byCount: steps)
  }
  
}

//struct VideoView_Previews: PreviewProvider {
//  static var previews: some View {
//    VideoView()
//  }
//}
