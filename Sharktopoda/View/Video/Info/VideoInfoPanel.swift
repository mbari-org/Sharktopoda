//
//  VideoInfoPanel.swift
//  Created for Sharktopoda on 9/22/25.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit
import SwiftUI

final class VideoInfoPanel {
  private static var windowController: NSWindowController?

  static func show() {
    guard let videoWindow = NSApp.keyWindow as? VideoWindow else {
      NSSound.beep()
      return
    }

    let content = VideoInfoContent(windowData: videoWindow.windowData)
    let panel = NSPanel(contentViewController: NSHostingController(rootView: content))
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    panel.title = "Sharktopoda \(appVersion) — Video Info"
    panel.styleMask = [.titled, .closable]
    panel.isReleasedWhenClosed = false

    let controller = NSWindowController(window: panel)
    windowController = controller
    controller.showWindow(nil)
    panel.center()
  }
}
