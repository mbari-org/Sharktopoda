//
//  ControlClose.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlClose: ControlMessage {
  var command: ControlCommand
  var uuid: String
  
  func process() -> ControlResponse {
    let idNorm = uuid.lowercased()

    if UDP.sharktopodaData.openVideos.enqueueIfLoading(id: idNorm, command: { videoWindow in
      DispatchQueue.main.async { [weak videoWindow] in
        videoWindow?.close()
      }
    }) {
      return ok()
    }

    DispatchQueue.main.async {
      UDP.sharktopodaData.close(id: uuid)
    }

    return ok()
  }
}
