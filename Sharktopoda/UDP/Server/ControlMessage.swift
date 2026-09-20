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
}

extension ControlMessage {
  typealias VideoWindowFn = (_ videoWindow: VideoWindow) -> ControlResponse

  func withVideoWindow(id: String,
                       deferIfLoading: Bool = true,
                       fn: @escaping VideoWindowFn) -> ControlResponse {
    let idNorm = id.lowercased()

    if deferIfLoading,
       UDP.sharktopodaData.openVideos.enqueueIfLoading(id: idNorm, command: { videoWindow in
         _ = fn(videoWindow)
       }) {
      return ok()
    }

    guard let videoWindow = UDP.sharktopodaData.window(for: idNorm) else {
      return failed("No video for uuid")
    }

    return fn(videoWindow)
  }

  typealias WindowDataFn = (_ windowData: WindowData) -> ControlResponse

  func withWindowData(id: String,
                      deferIfLoading: Bool = true,
                      fn: @escaping WindowDataFn) -> ControlResponse {
    withVideoWindow(id: id, deferIfLoading: deferIfLoading) { videoWindow in
      fn(videoWindow.windowData)
    }
  }
}
