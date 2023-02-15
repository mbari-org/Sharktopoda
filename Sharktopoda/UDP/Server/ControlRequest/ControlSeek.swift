//
//  ControlSeek.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlSeek: ControlMessage {
  var command: ControlCommand
  let uuid: String
  let elapsedTimeMillis: Int
  
  func process() -> ControlResponse {
    withWindowData(id: uuid) { windowData in
      DispatchQueue.main.async { [weak windowData] in
        guard let windowData else { return }
        let playerDirection = windowData.playerDirection
        windowData.seek(elapsedTime: elapsedTimeMillis)
        windowData.playerResume(playerDirection)
      }
      return ok()
    }
  }
}
