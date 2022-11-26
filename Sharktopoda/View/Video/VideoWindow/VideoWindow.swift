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
  @StateObject private var windowData = WindowData()
  
  var keyInfo: KeyInfo

  /// Queue on which off-main work is done
  let queue: DispatchQueue

  //
  init(for videoAsset: VideoAsset, with sharktopodaData: SharktopodaData) {
    keyInfo = KeyInfo(keyTime: Date())
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


    let frame = NSMakeRect(0, 0, fullSize.width, fullSize.height)
    let frameDuration = videoAsset.frameDuration
    let playerItem = AVPlayerItem(asset: videoAsset.avAsset)
    
    windowData.id = videoAsset.id
    windowData.player = AVPlayer(playerItem: playerItem)
    windowData.localizations = Localizations(id: videoAsset.id,
                                             frameDuration: frameDuration.asMillis())
    windowData.videoControl = VideoControl(windowData: windowData)
    windowData.playerView = PlayerView(frame: frame)
    
    let videoView = VideoView()
      .environmentObject(windowData) as! VideoView

    contentView = NSHostingView(rootView: videoView)
    delegate = self
    
    let pollingInterval = CMTimeMultiplyByFloat64(videoAsset.frameDuration,
                                                  multiplier: 0.66)
    setLocalizationsObserver(pollingInterval)
        
    makeKeyAndOrderFront(nil)
  }
  
  var id: String {
    windowData.id
  }
}

extension VideoWindow {
  var fullSize: CGSize {
    windowData.fullSize
  }
  
  var localizations: Localizations {
    windowData.localizations
  }
  
  var playerView: PlayerView {
    windowData.playerView
  }

  var videoAsset: VideoAsset {
    windowData.videoAsset
  }

  var videoControl: VideoControl {
    windowData.videoControl
  }
}

