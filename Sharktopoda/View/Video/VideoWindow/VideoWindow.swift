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
  var videoView: VideoView
  var keyInfo: KeyInfo

  let localizations: Localizations
  var playerControl: PlayerControl
  
  var videoValues = VideoValues()
  
  /// Queue on which off-main work is done
  let queue: DispatchQueue

  //
  init(for videoAsset: VideoAsset) {
    keyInfo = KeyInfo(keyTime: Date())
    
    videoView = VideoView(videoAsset: videoAsset, sharktopodaData: UDP.sharktopodaData)
    
    let seekTolerance = CMTimeMultiplyByFloat64(videoAsset.frameDuration,
                                                multiplier: 0.25)
    
    playerControl = PlayerControl(player: videoView.player,
                                  seekTolerance: seekTolerance)
    
    localizations = Localizations(frameDuration: videoAsset.frameDuration.asMillis(),
                                  videoId: videoAsset.id)
    
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
    
    setLocalizationsObserver()
        
    makeKeyAndOrderFront(nil)
  }
  
  var playerView: PlayerView {
    videoView.playerView
  }
  
  var url: URL {
    videoView.videoAsset.url
  }

  var videoAsset: VideoAsset {
    videoView.videoAsset
  }
}
