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

class VideoWindow: NSWindow {
  struct KeyInfo {
    var keyTime: Date
    var isKey: Bool = false
    
    static func <(lhs: KeyInfo, rhs: KeyInfo) -> Bool {
      lhs.keyTime < rhs.keyTime
    }
  }
  
  var keyInfo: KeyInfo

  var videoPlayerView: VideoPlayerView
  
  var videoAsset: VideoAsset {
    get {
      videoPlayerView.videoAsset
    }
  }

  init(for videoAsset: VideoAsset) {
    keyInfo = KeyInfo(keyTime: Date())

    videoPlayerView = VideoPlayerView(videoAsset: videoAsset)

    let videoSize = videoAsset.size!
    super.init(
      contentRect: NSMakeRect(0, 0, videoSize.width, videoSize.height),
      styleMask: [.titled, .closable, .miniaturizable, .resizable],
      backing: .buffered,
      defer: false)

    center()
    isReleasedWhenClosed = false
    title = videoAsset.id

    contentView = videoPlayerView
    delegate = self
    
    makeKeyAndOrderFront(nil)
  }
}

/// Convenience functions
extension VideoWindow {
  func canStep(_ steps: Int) -> Bool {
    videoPlayerView.canStep(steps)
  }
  
  func playbackTime() -> Int {
    videoPlayerView.playerTime
  }

  func frameGrab(at captureTime: Int, destination: String) async -> FrameGrabResult {
    await videoPlayerView.frameGrab(at: captureTime, destination: destination)
  }
  
  var id: String {
    videoAsset.id
  }
  
  func pause() {
    videoPlayerView.pause()
  }
  
  func play(rate: Float) {
    videoPlayerView.rate = rate
  }
  
  var rate: Float {
    videoPlayerView.rate
  }
  
  func seek(elapsed: Int) {
    videoPlayerView.seek(elapsed: elapsed)
  }
  
  func step(_ steps: Int) {
    videoPlayerView.step(steps)
  }
  
  var url: URL {
    videoAsset.url
  }
}

/// Localizations
extension VideoWindow {
  func addLocalizations(_ controlLocalizations: [ControlLocalization]) -> [Bool] {
    controlLocalizations
      .map { Localization(from: $0) }
      .map { videoPlayerView.addLocalization($0) }
  }
  
  func clearLocalizations() {
    videoPlayerView.clearLocalizations()
  }
  
  func removeLocalizations(_ ids: [String]) -> [Bool] {
    videoPlayerView.removeLocalizations(ids)
  }

  func selectLocalizations(_ ids: [String]) -> [Bool] {
    videoPlayerView.selectLocalizations(ids)
  }
  
  func updateLocalizations(_ controlLocalizations: [ControlLocalization]) -> [Bool] {
    controlLocalizations
      .map { Localization(from: $0) }
      .map { videoPlayerView.updateLocalization($0) }
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
  
  static func scaleSize(size: NSSize) -> NSSize {
    let screenFrame = NSScreen.main!.frame
    let maxSize = NSMakeSize(0.9 * screenFrame.width, 0.9 * screenFrame.height)
    
    if size.width < maxSize.width && size.height < maxSize.height {
      return size
    }
    
    let widthScale: CGFloat = maxSize.width / size.width
    let heightScale: CGFloat = maxSize.height / size.height
    
    let scale = widthScale < heightScale ? widthScale : heightScale
    
    return NSMakeSize(size.width * scale, size.height * scale)
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
      do {
        if !(try url.checkResourceIsReachable()) {
          return OpenVideoError.notReachable
        }
      } catch let error {
        return error
      }

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
    self.keyInfo = KeyInfo(keyTime: Date(), isKey: true)
  }
  
  func windowDidResignKey(_ notification: Notification) {
    self.keyInfo = KeyInfo(keyTime: self.keyInfo.keyTime, isKey: false)
  }
  
  func windowDidResize(_ notification: Notification) {
    DispatchQueue.main.async { [weak self] in
      self?.videoPlayerView.resized()
//      self?.layoutIfNeeded()
    }
  }
}
