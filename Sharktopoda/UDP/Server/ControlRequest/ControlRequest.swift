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

  typealias VideoControlFn = (_ videoControl: VideoControl) -> ControlResponse
  func withVideoControl(id: String,
                         fn: VideoControlFn) -> ControlResponse {
    withWindowData(id: id) { windowData in
      fn(windowData.videoControl)
    }
  }

  typealias PlayerViewFn = (_ playerView: PlayerView) -> ControlResponse
  func withPlayerView(id: String,
                      fn: PlayerViewFn) -> ControlResponse {
    withWindowData(id: id) { windowData in
      fn(windowData.playerView)
    }
  }

  typealias VideoAssetFn = (_ videoAsset: VideoAsset) -> ControlResponse
  func withVideoAsset(id: String,
                      fn: VideoAssetFn) -> ControlResponse {
    withWindowData(id: id) { windowData in
      fn(windowData.videoAsset)
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
  
  typealias WindowDataFn = (_ windowData: WindowData) -> ControlResponse
  func withWindowData(id: String,
                      fn: WindowDataFn) -> ControlResponse {
    withVideoWindow(id: id) { videoWindow in
      fn(videoWindow.windowData)
    }
  }
  
}
