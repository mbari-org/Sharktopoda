//
//  VideoWindow.swift
//  Created for Sharktopoda on 9/26/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit
import AVKit
import SwiftUI

final class VideoWindow: NSWindow {
  var id: String
  var videoAsset: VideoAsset
  
  var videoView: VideoView
  var keyInfo: KeyInfo

  let localizations: Localizations
  var videoControl: VideoControl
  
  /// Queue on which off-main work is done
  let queue: DispatchQueue

  //
  init(for videoAsset: VideoAsset) {
    id = videoAsset.id
    self.videoAsset = videoAsset
    
    keyInfo = KeyInfo(keyTime: Date())
    
    localizations = Localizations(frameDuration: videoAsset.frameDuration.asMillis(),
                                  videoId: videoAsset.id)
        
    let playerItem = AVPlayerItem(asset: videoAsset.avAsset)
    let player = AVPlayer(playerItem: playerItem)
    
    videoControl = VideoControl(player: player, videoAsset: videoAsset)
    
    videoView = VideoView(localizations: localizations,
                          videoControl: videoControl)

    queue = DispatchQueue(label: "Sharktopoda Video Queue: \(videoAsset.id)")
    
    let fullSize = videoAsset.fullSize
    super.init(
      contentRect: NSMakeRect(0, 0, fullSize.width, fullSize.height),
      styleMask: [.titled, .closable, .miniaturizable, .resizable],
      backing: .buffered,
      defer: false)
    
    center()
    isReleasedWhenClosed = false
    title = videoAsset.id
    
    contentView = NSHostingView(rootView: videoView)
    delegate = self
    
    let pollingInterval = CMTimeMultiplyByFloat64(videoAsset.frameDuration,
                                                  multiplier: 0.66)
    setLocalizationsObserver(pollingInterval)
        
    makeKeyAndOrderFront(nil)
  }
  
  var playerView: PlayerView {
    videoView.playerView
  }
  
//  var url: URL {
//    videoView.videoAsset.url
//  }
//
//  var videoAsset: VideoAsset {
//    videoView.videoAsset
//  }
}
