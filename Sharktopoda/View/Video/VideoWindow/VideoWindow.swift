//
//  VideoWindow.swift
//  Created for Sharktopoda on 9/26/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit
import AVKit
import Combine
import SwiftUI

final class VideoWindow: NSWindow {
  var windowData = WindowData()
  
  /// Queue for playerTime observation
  let playerTimeQueue: DispatchQueue

  /// Background Task for resizing localizations
  var resizingTask: Task<(), Never>?

  /// Used by delegate to pause/resume playback after resizing
  var playerDirection: WindowData.PlayerDirection?
  
  var showLocalizationsSubscription: AnyCancellable?
  
  init(for videoAsset: VideoAsset, with sharktopodaData: SharktopodaData) {
    playerTimeQueue = DispatchQueue(label: "Sharktopoda Player Time Queue: \(videoAsset.id)")

    let fullSize = videoAsset.fullSize

    // CxTBD The explicit sizing of the window (via width - 120) and the VideoControlView
    // frame (via height: 50) needs to be investigated
    
    super.init(
      contentRect: NSMakeRect(0, 0, fullSize.width - 120, fullSize.height),
      styleMask: [.titled, .closable, .miniaturizable, .resizable],
      backing: .buffered,
      defer: false)
    
    center()
    isReleasedWhenClosed = false
    title = videoAsset.url.lastPathComponent
    backgroundColor = NSColor(Color.init(hex: "342A27")!)

    let frameDuration = videoAsset.frameDuration
    let playerItem = AVPlayerItem(asset: videoAsset.avAsset)
    
    windowData.id = videoAsset.id

    windowData.frameDuration = frameDuration
    windowData.fullSize = videoAsset.fullSize
    windowData.localizationData = LocalizationData(id: videoAsset.id,
                                                   frameDuration: frameDuration.asMillis())
    windowData.player = AVPlayer(playerItem: playerItem)
    windowData.playerView = PlayerView()
    windowData.videoAsset = videoAsset
    windowData.videoControl = VideoControl(windowData: windowData)
    
    let _ = windowData.playerView.environmentObject(windowData)
    
    contentView = NSHostingView(rootView: VideoView().environmentObject(windowData))

    delegate = self
    
    let pollingInterval = CMTimeMultiplyByFloat64(videoAsset.frameDuration,
                                                  multiplier: 0.33)
    setPlayerObserver(pollingInterval)
    
    showLocalizationsSubscription = windowData.$showLocalizations.sink(receiveValue: { [weak windowData] newValue in
      if (newValue) {
        windowData?.displaySpanned(force: true)
      } else {
        windowData?.playerView.clear()
      }
    })

        
    bringToFront()
  }
  
  var id: String {
    windowData.id
  }
  
  func bringToFront() {
    makeKeyAndOrderFront(nil)
  }
}
