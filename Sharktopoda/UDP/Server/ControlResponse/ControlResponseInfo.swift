//
//  ControlResponseInfo.swift
//  Created for Sharktopoda on 9/30/22.
//
//  Apache License 2.0 — See project LICENSE file
//

struct ControlResponseInfo: ControlResponse {
  var response: ControlCommand
  var status: ControlResponseStatus

  var uuid: String?
  var url: String?
  var durationMillis: Int?
  var frameRate: Float?
  var isKey: Bool?
  
  init(using videoInfo: VideoInfo) {
    response = .info
    status = .ok
    self.uuid = videoInfo.uuid
    self.url = videoInfo.url
    self.durationMillis = videoInfo.durationMillis
    self.frameRate = videoInfo.frameRate
    self.isKey = videoInfo.isKey
  }

  init(using videoWindow: VideoWindow) {
    let windowInfo = VideoInfo(using: videoWindow)
    self.init(using: windowInfo)
  }
}
