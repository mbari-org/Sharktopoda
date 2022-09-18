//
//  SharktopodaApp.swift
//  Created for Sharktopoda on 9/12/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

@main
struct SharktopodaApp: App {
  init() {
    UDPServer.singleton.start()
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .commands {
      SharktopodaCommands()
    }

    Settings {
      Preferences()
    }
  }
}
