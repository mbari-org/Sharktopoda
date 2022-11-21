//
//  ControlMessage.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

protocol ControlRequest: Decodable, CustomStringConvertible {
  var command: ControlCommand { get set }
  
  func process() -> ControlResponse
}

extension ControlRequest {
  var description: String {
    command.rawValue
  }
  
  func ok() -> ControlResponse {
    ControlResponseOk(response: command)
  }
  
  func failed(_ cause: String) -> ControlResponse {
    ControlResponseFailed(response: command, cause: cause)
  }
  
  typealias LocalizationsFn = (_: Localizations) -> ControlResponse
  func withLocalizations(id: String,
                         fn: LocalizationsFn) -> ControlResponse {
    withVideoWindow(id: id) { videoWindow in
      fn(videoWindow.localizations)
    }
  }
  
  typealias PlayerControlFn = (_ playerControl: PlayerControl) -> ControlResponse
  func withPlayerControl(id: String,
                         fn: PlayerControlFn) -> ControlResponse {
    withVideoWindow(id: id) { videoWindow in
      fn(videoWindow.playerControl)
    }
  }

  typealias PlayerViewFn = (_ playerView: PlayerView) -> ControlResponse
  func withPlayerView(id: String,
                      fn: PlayerViewFn) -> ControlResponse {
    withVideoWindow(id: id) { videoWindow in
      fn(videoWindow.playerView)
    }
  }

  typealias VideoAssetFn = (_ videoAsset: VideoAsset) -> ControlResponse
  func withVideoAsset(id: String,
                      fn: VideoAssetFn) -> ControlResponse {
    withVideoWindow(id: id) { videoWindow in
      fn(videoWindow.videoAsset)
    }
  }

  typealias VideoWindowFn = (_ videoWindow: VideoWindow) -> ControlResponse
  func withVideoWindow(id: String,
                       fn: VideoWindowFn) -> ControlResponse {
    guard let videoWindow = UDP.sharktopodaData.videoWindows[id] else {
      return failed("No video for uuid")
    }
    
    return fn(videoWindow)
  }
  
}
