//
//  SharktopodaAppDelegate.swift
//  Created for Sharktopoda on 11/17/22.
//
//  Apache License 2.0 — See project LICENSE file
//
import AppKit

class SharktopodaAppDelegate: NSObject, NSApplicationDelegate {
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
        if let nextVideoWindow = sharktopodaData.closeLatest() {
          nextVideoWindow.bringToFront()
        }
        return .terminateCancel
    }
  }
}
