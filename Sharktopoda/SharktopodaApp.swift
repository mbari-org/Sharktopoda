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

  @NSApplicationDelegateAdaptor private var appDelegate: SharktopodaAppDelegate

  init() {
    setAppDefaults()
  }
  
  var body: some Scene {
    Window("Sharktopoda", id: "SharktopodaApp") {
      MainView().environmentObject(sharktopodaData)
    }
    .commands { SharktopodaCommands() }

    Settings {
      Preferences().environmentObject(sharktopodaData)
    }
  }
}
