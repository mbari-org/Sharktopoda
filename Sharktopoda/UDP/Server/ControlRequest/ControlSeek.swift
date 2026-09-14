//
//  ControlSeek.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

struct ControlSeek: ControlMessage {
  var command: ControlCommand
  let uuid: String
  let elapsedTimeMillis: Int
  
  func process() -> ControlResponse {
    withWindowData(id: uuid) { windowData in
      guard elapsedTimeMillis >= 0 else {
        return failed("elapsedTimeMillis before start")
      }

      let frame = windowData.videoAsset.frame(forMillis: elapsedTimeMillis)
      guard frame <= windowData.videoAsset.lastFrame else {
        return failed("elapsedTimeMillis past end")
      }

      DispatchQueue.main.async { [weak windowData] in
        guard let windowData else { return }

        windowData.seek(frame: frame)
        windowData.playerResume(windowData.playerDirection)
      }
      return ok()
    }
  }
}
