//
//  ControlResponseAllInfo.swift
//  Created for Sharktopoda on 9/30/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlResponseAllInfo: ControlResponse {
  var response: ControlCommand
  var status: ControlResponseStatus
  var videos: [ControlResponseInfo.VideoInfo]
  
  init(with videos: [ControlResponseInfo.VideoInfo]) {
    response = .all
    status = .ok
    self.videos = videos
  }
}
  
