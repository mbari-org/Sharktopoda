//
//  SharktopodaApp.swift
//  Created for Sharktopoda on 9/12/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

@main
struct SharktopodaApp: App {
  @NSApplicationDelegateAdaptor private var appDelegate: SharktopodaAppDelegate
  
  @Environment(\.openWindow) private var openWindow

  @StateObject private var sharktopodaData = SharktopodaData()

  init() {
    setAppDefaults()
  }
  
  var body: some Scene {
    Window("Sharktopoda", id: "SharktopodaApp") {
      MainView().environmentObject(sharktopodaData)
    }
    .commands { SharktopodaCommands() }

    WindowGroup("Video", for: VideoAsset.ID.self) { $videoId in
      if let videoId = videoId,
         sharktopodaData.videoAssets[videoId] != nil {
        VideoView(id: videoId, model: sharktopodaData)
//        VideoView(id: videoId!).environmentObject(sharktopodaData)
      }
    }
    
    Settings {
      Preferences().environmentObject(sharktopodaData)
    }
  }
}
