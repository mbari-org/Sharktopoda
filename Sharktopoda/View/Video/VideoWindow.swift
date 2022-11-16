//
//  VideoWindow.swift
//  Created for Sharktopoda on 9/26/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import AppKit
import AVFoundation
import SwiftUI

final class VideoWindow: NSWindow {

  var videoPlayerView: VideoPlayerView
  var videoAsset: VideoAsset {
    videoPlayerView.videoAsset
  }
  var keyInfo: KeyInfo

  init(for videoAsset: VideoAsset) {
    keyInfo = KeyInfo(keyTime: Date())
    videoPlayerView = VideoPlayerView(videoAsset: videoAsset)

    let fullSize = videoAsset.size!
    super.init(
      contentRect: NSMakeRect(0, 0, fullSize.width, fullSize.height),
      styleMask: [.titled, .closable, .miniaturizable, .resizable],
      backing: .buffered,
      defer: false)

    center()
    isReleasedWhenClosed = false
    title = videoAsset.id

    contentView = NSHostingView(rootView: videoPlayerView)

    delegate = self
    makeKeyAndOrderFront(nil)
  }
}

extension VideoWindow {
  struct KeyInfo {
    var keyTime: Date
    var isKey: Bool = false
    
    static func <(lhs: KeyInfo, rhs: KeyInfo) -> Bool {
      lhs.keyTime < rhs.keyTime
    }
  }
}

/// Convenience functions
extension VideoWindow {
  override func keyDown(with event: NSEvent) {
    enum KeyCode: UInt16 {
      case space = 49
      case delete = 51
    }
    
    func isCommand(_ event: NSEvent) -> Bool {
      event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command
    }
    
    func isControl(_ event: NSEvent) -> Bool {
      event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .control
    }

    /// Cmd-Delete:  Delete selected localizations
    if event.keyCode == KeyCode.delete.rawValue,
       isCommand(event) {
      let _ = playerView.deleteSelected()
      return
    }
    
    /// Space:  Toggle play/pause forward
    /// Ctrl-Space:  Toggle play/pause reverse
    if event.keyCode == KeyCode.space.rawValue {
      let rate: Float = isControl(event) ? -1 : 1
      playerView.paused ? play(rate: rate) : pause()
      return
    }

    super.keyDown(with: event)
  }
  
  var playerView: NSPlayerView {
    get {
      videoPlayerView.playerView.nsPlayerView
    }
  }
  
  func canStep(_ steps: Int) -> Bool {
    playerView.canStep(steps)
  }
  
  func playbackTime() -> Int {
    playerView.currentTime
  }

  func frameGrab(at captureTime: Int, destination: String) async -> FrameGrabResult {
    await playerView.frameGrab(at: captureTime, destination: destination)
  }
  
  var id: String {
    videoAsset.id
  }
  
  func pause() {
    playerView.pause()
  }
  
  func play(rate: Float = 1.0) {
    playerView.rate = rate
  }
  
  var rate: Float {
    playerView.rate
  }
  
  func seek(elapsed: Int) {
    playerView.seek(elapsed: elapsed)
  }
  
  func step(_ steps: Int) {
    playerView.step(steps)
  }
  
  var url: URL {
    videoAsset.url
  }
}

/// Localizations
extension VideoWindow {
  func addLocalizations(_ controlLocalizations: [ControlLocalization]) -> [Bool] {
    controlLocalizations
      .map { Localization(from: $0, with: videoAsset.size!) }
      .map { playerView.addLocalization($0) }
  }
  
  func clearLocalizations() {
    playerView.clearLocalizations()
  }
  
  func removeLocalizations(_ ids: [String]) -> [Bool] {
    playerView.removeLocalizations(ids)
  }

  func selectLocalizations(_ ids: [String]) -> [Bool] {
    playerView.selectLocalizations(ids)
  }
  
  func updateLocalizations(_ controlLocalizations: [ControlLocalization]) -> [Bool] {
    controlLocalizations
      .map { playerView.updateLocalization($0) }
  }
}

/// Function overrides
extension VideoWindow {
  override func makeKeyAndOrderFront(_ sender: Any?) {
    super.makeKeyAndOrderFront(sender)
    self.keyInfo = KeyInfo(keyTime: Date(), isKey: true)
  }
}

/// Static functions
extension VideoWindow {
  static func <(lhs: VideoWindow, rhs: VideoWindow) -> Bool {
    lhs.keyInfo < rhs.keyInfo
  }
  
  static func open(path: String) -> Error? {
    open(id: path, url: URL(fileURLWithPath: path))
  }
  
  static func open(id: String, url: URL) -> Error? {
    if let videoWindow = UDP.sharktopodaData.videoWindows.values.first(where: { $0.url == url } ) {
      DispatchQueue.main.async {
        videoWindow.makeKeyAndOrderFront(nil)
      }
    } else {
      let videoAsset = VideoAsset(id: id, url: url)
      guard videoAsset.avAsset.isPlayable else {
        return OpenVideoError.notPlayable
      }
      DispatchQueue.main.async {
        let videoWindow = VideoWindow(for: videoAsset)
        videoWindow.makeKeyAndOrderFront(nil)
        UDP.sharktopodaData.videoWindows[id] = videoWindow
      }
    }
    return nil
  }
}

extension VideoWindow: NSWindowDelegate {
  func windowWillClose(_ notification: Notification) {
    DispatchQueue.main.async {
      UDP.sharktopodaData.videoWindows.removeValue(forKey: self.videoAsset.id)
    }
  }
  
  func windowDidBecomeKey(_ notification: Notification) {
    keyInfo = KeyInfo(keyTime: Date(), isKey: true)
  }
  
  func windowDidResignKey(_ notification: Notification) {
    keyInfo = KeyInfo(keyTime: keyInfo.keyTime, isKey: false)
  }
  
  func windowDidResize(_ notification: Notification) {
    playerView.resized()
  }
}
