//
//  ControlMessage.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

protocol ControlMessage: Decodable, CustomStringConvertible {
  var command: ControlCommand { get set }
  
  func process() -> ControlResponse
}

extension ControlMessage {
  var description: String {
    command.rawValue
  }
  
  func ok() -> ControlResponse {
    ControlResponseOk(response: command)
  }
  
  func failed(_ cause: String) -> ControlResponse {
    ControlResponseFailed(response: command, cause: cause)
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
