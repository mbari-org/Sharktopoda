//
//  SharktopodaAppDelegate.swift
//  Created for Sharktopoda on 11/17/22.
//
//  Apache License 2.0 — See project LICENSE file
//
import AppKit

class SharktopodaAppDelegate: NSObject, NSApplicationDelegate {
  func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
    if UDP.sharktopodaData.hasOpenVideos {
      if let latestWindow = UDP.sharktopodaData.latestVideoWindow() {
        latestWindow.bringToFront()
      }
      return .terminateCancel
    } else {
      return .terminateNow
    }
  }
}
