//
//  SharktopodaAppDelegate.swift
//  Created for Sharktopoda on 11/17/22.
//
//  Apache License 2.0 — See project LICENSE file
//
import AppKit

class SharktopodaAppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ notification: Notification) {
    DispatchQueue.main.async {
      guard UDP.sharktopodaData.mainViewWindow == nil else { return }
      UDP.sharktopodaData.mainViewWindow =
        NSApp.windows.first(where: { $0.title == "Sharktopoda" }) ?? NSApp.mainWindow
    }
  }
}
