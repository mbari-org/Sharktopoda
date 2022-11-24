//
//  VideoWindowData.swift
//  Created for Sharktopoda on 11/24/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

extension VideoWindow {
  typealias LocalizationsFn = (_ localizations: Localizations) -> Void
  typealias VideoControlFn = (_ videoControl: VideoControl) -> Void
  typealias VideoViewFn = (_ videoView: VideoView) -> Void
  typealias VideoWindowFn = (_ videoWindow: VideoWindow) -> Void

  static func withLocalizations(id: String, _ fn: LocalizationsFn) {
    withVideoWindow(id: id) { fn($0.localizations) }
  }
  
  static func withVideoControl(id: String, _ fn: VideoControlFn) {
    withVideoWindow(id: id) { fn($0.videoControl) }
  }
  
  static func withVideoView(id: String, _ fn: VideoViewFn) {
    withVideoWindow(id: id) { fn($0.videoView) }
  }
  
  static func withVideoWindow(id: String, _ fn: VideoWindowFn) {
    guard let videoWindow = UDP.sharktopodaData.videoWindows[id] else { return }
    fn(videoWindow)
  }
}
