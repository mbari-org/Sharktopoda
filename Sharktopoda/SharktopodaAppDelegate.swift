//
//  SharktopodaAppDelegate.swift
//  Created for Sharktopoda on 11/17/22.
//
//  Apache License 2.0 — See project LICENSE file
//
import AppKit

class SharktopodaAppDelegate: NSObject, NSApplicationDelegate {
//  func applicationDidFinishLaunching(_ notification: Notification) {
//    NSApp.windows.last?.makeMain()
//    NSApp.windows.last?.makeKeyAndOrderFront(nil)
//  }
  
  func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
    guard let sharktopodaData = UDP.sharktopodaData else { return .terminateNow }

    switch sharktopodaData.videoWindowsState {
      case .noneOpen:
        return .terminateNow
        
      case .soloKey:
        return .terminateNow

      case .noKey:
        sharktopodaData.latestVideoWindow()?.bringToFront()
        return .terminateCancel

      case .multiKey:
        sharktopodaData.closeLatest()
        return .terminateCancel
    }
  }
}
