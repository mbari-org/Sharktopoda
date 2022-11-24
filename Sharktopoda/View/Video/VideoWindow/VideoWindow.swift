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
  var keyInfo: KeyInfo

  let localizations: Localizations

  var videoAsset: VideoAsset
  var videoControl: VideoControl
  var videoView: VideoView

  /// Queue on which off-main work is done
  let queue: DispatchQueue

  //
  init(for videoAsset: VideoAsset) {
    let id = videoAsset.id
    
    self.id = id
    keyInfo = KeyInfo(keyTime: Date())

    self.videoAsset = videoAsset

    let frameDuration = videoAsset.frameDuration
    localizations = Localizations(id: id,
                                  frameDuration: frameDuration.asMillis())
        
    let playerItem = AVPlayerItem(asset: videoAsset.avAsset)
    let player = AVPlayer(playerItem: playerItem)
    
    videoControl = VideoControl(id: id,
                                frameDuration: frameDuration,
                                fullSize: videoAsset.fullSize,
                                player: player)
    
    videoView = VideoView(id: id,
                          localizations: localizations,
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
