//
//  VideoWindow.swift
//  Created for Sharktopoda on 9/26/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit
import AVKit
import SwiftUI

final class VideoWindow: NSWindow {
  var videoView: VideoView
  var keyInfo: KeyInfo
  //
  init(for videoAsset: VideoAsset) {
    keyInfo = KeyInfo(keyTime: Date())
    videoView = VideoView(videoAsset)
    
    let fullSize = videoAsset.fullSize
    super.init(
      contentRect: NSMakeRect(0, 0, fullSize.width, fullSize.height),
      styleMask: [.titled, .closable, .miniaturizable, .resizable],
      backing: .buffered,
      defer: false)
    
    center()
    isReleasedWhenClosed = false
    title = videoAsset.id
    
    contentView = NSHostingView(rootView: videoView)
    
    delegate = self
    makeKeyAndOrderFront(nil)
  }
  
  var videoAsset: VideoAsset {
    videoView.videoAsset
  }
  var url: URL {
    videoView.videoAsset.url
  }

}

///// Convenience functions
//extension VideoWindow {
//  override func keyDown(with event: NSEvent) {
//    enum KeyCode: UInt16 {
//      case space = 49
//      case delete = 51
//    }
//    
//    func isCommand(_ event: NSEvent) -> Bool {
//      event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command
//    }
//    
//    func isControl(_ event: NSEvent) -> Bool {
//      event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .control
//    }
//
//    /// Cmd-Delete:  Delete selected localizations
//    if event.keyCode == KeyCode.delete.rawValue,
//       isCommand(event) {
//      let _ = playerView.deleteSelected()
//      return
//    }
//    
//    /// Space:  Toggle play/pause forward
//    /// Ctrl-Space:  Toggle play/pause reverse
//    if event.keyCode == KeyCode.space.rawValue {
//      let rate: Float = isControl(event) ? -1 : 1
//      playerView.paused ? play(rate: rate) : pause()
//      return
//    }
//
//    super.keyDown(with: event)
//  }
//  
//  var playerView: AVPlayerView {
//    get {
//      videoPlayerView.playerView
//    }
//  }
//  
//  func canStep(_ steps: Int) -> Bool {
//    playerView.canStep(steps)
//  }
//  
//  func playbackTime() -> Int {
//    playerView.currentTime
//  }
//
//  func frameGrab(at captureTime: Int, destination: String) async -> FrameGrabResult {
//    await playerView.frameGrab(at: captureTime, destination: destination)
//  }
//  
//  var id: String {
//    videoAsset.id
//  }
//  
//  func pause() {
//    playerView.pause()
//  }
//  
//  func play(rate: Float = 1.0) {
//    playerView.rate = rate
//  }
//  
//  var rate: Float {
//    playerView.rate
//  }
//  
//  func seek(elapsed: Int) {
//    playerView.seek(elapsed: elapsed)
//  }
//  
//  func step(_ steps: Int) {
//    playerView.step(steps)
//  }
//  
//  var url: URL {
//    videoAsset.url
//  }
//}
//
///// Localizations
//extension VideoWindow {
//  func addLocalizations(_ controlLocalizations: [ControlLocalization]) -> [Bool] {
//    controlLocalizations
//      .map { Localization(from: $0, with: videoAsset.fullSize) }
//      .map { playerView.addLocalization($0) }
//  }
//  
//  func clearLocalizations() {
//    playerView.clearLocalizations()
//  }
//  
//  func removeLocalizations(_ ids: [String]) -> [Bool] {
//    playerView.removeLocalizations(ids)
//  }
//
//  func selectLocalizations(_ ids: [String]) -> [Bool] {
//    playerView.selectLocalizations(ids)
//  }
//  
//  func updateLocalizations(_ controlLocalizations: [ControlLocalization]) -> [Bool] {
//    controlLocalizations
//      .map { playerView.updateLocalization($0) }
//  }
//}
//
///// Function overrides
//extension VideoWindow {
//  override func makeKeyAndOrderFront(_ sender: Any?) {
//    super.makeKeyAndOrderFront(sender)
//    self.keyInfo = KeyInfo(keyTime: Date(), isKey: true)
//  }
//}
//
///// Static functions
extension VideoWindow {
  static func open(path: String) -> Error? {
    // CxInc
//    open(id: path, url: URL(fileURLWithPath: path))
    return OpenVideoError.unknown("CxInc VideoWindow.open(path)")
  }
  
  static func open(id: String) -> Error? {
    if let videoWindow = UDP.sharktopodaData.videoWindows[id] {
      DispatchQueue.main.async {
        videoWindow.makeKeyAndOrderFront(nil)
      }
    } else {
      guard let videoAsset = UDP.sharktopodaData.tmpVideoAssets[id] else {
        return OpenVideoError.notLoaded
      }
      
      guard videoAsset.isPlayable else {
        return OpenVideoError.notPlayable
      }
      
      UDP.sharktopodaData.tmpVideoAssets[id] = nil
      
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
      // CxInc
//      UDP.sharktopodaData.videoWindows.removeValue(forKey: self.videoAsset.id)
    }
  }
  
  func windowDidBecomeKey(_ notification: Notification) {
    keyInfo = KeyInfo(keyTime: Date(), isKey: true)
  }
  
  func windowDidResignKey(_ notification: Notification) {
    keyInfo = KeyInfo(keyTime: keyInfo.keyTime, isKey: false)
  }
  
  func windowDidResize(_ notification: Notification) {
    // CxInc
//    playerView.resized()
  }
}
