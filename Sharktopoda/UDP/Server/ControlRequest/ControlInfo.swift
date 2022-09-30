//
//  ControlInfo.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

struct ControlInfo: ControlRequest {
  var command: ControlCommand
  
  func process() -> ControlResponse {
    if let latestWindow = UDP.sharktopodaData.latedVideoWindow() {
      let videoAsset = latestWindow.videoView.videoAsset
      return ControlResponseInfo(uuid: videoAsset.uuid,
                                 durationMillis: videoAsset.durationMillis,
                                 frameRate: videoAsset.frameRate,
                                 key: latestWindow.isKeyWindow)
    }

    return failed("No open videos")
  }
}
