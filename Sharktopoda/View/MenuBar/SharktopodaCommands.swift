//
//  SharktopodaCommands.swift
//  Created for Sharktopoda on 9/17/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct SharktopodaCommands: Commands {
  var body: some Commands {
    CommandGroup(after: CommandGroupPlacement.newItem) {
      Divider()

      OpenFileView()
        .keyboardShortcut("O", modifiers: [.command])

      OpenUrlView()
        .keyboardShortcut("O", modifiers: [.shift, .command])
    }
    
    // CxTBD Needs work
//    CommandMenu("Video") {
//      Button("Play") {
//        videoWindow?.videoControl.play()
//      }
//      .disabled(videoWindow == nil || videoWindow!.videoControl.paused)
//
//      Button("Pause") {
//        videoWindow?.videoControl.pause()
//      }
//      .disabled(videoWindow == nil || !videoWindow!.videoControl.paused)
//    }
  }
  
  var videoWindow: VideoWindow? {
    get {
      // CxInc
//      UDP.sharktopodaData.latestVideoWindow()
      return nil
    }
  }

  var playerView: NSPlayerView? {
    get {
      // CxInc
//      videoWindow?.playerView
      return nil
    }
  }
}
