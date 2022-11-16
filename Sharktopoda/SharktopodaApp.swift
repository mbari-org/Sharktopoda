//
//  SharktopodaApp.swift
//  Created for Sharktopoda on 9/12/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

@main
struct SharktopodaApp: App {
  @StateObject private var sharktopodaData = SharktopodaData()
  
  init() {
    setAppDefaults()
  }
  
  var body: some Scene {
    WindowGroup {
      MainView()
        .environmentObject(sharktopodaData)
      
    }
    .commands {
      SharktopodaCommands()
    }

    WindowGroup("Video", for: VideoAsset.ID.self) { $videoId in
      VideoView(id: videoId!)
        .environmentObject(sharktopodaData)
    }
    
    Settings {
      Preferences()
        .environmentObject(sharktopodaData)
    }
  }
}
