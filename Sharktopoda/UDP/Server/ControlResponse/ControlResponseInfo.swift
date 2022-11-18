//
//  ControlResponseInfo.swift
//  Created for Sharktopoda on 9/30/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlResponseInfo: ControlResponse {
  struct VideoInfo: Codable {
    var uuid: String
    var url: String
    var durationMillis: Int
    var frameRate: Float
    var isKey: Bool

    // CxInc
//    init(using videoWindow: VideoWindow) {
//      let videoAsset = videoWindow.videoAsset
//      self.uuid = videoAsset.id
//      self.url = videoAsset.url.absoluteString
//      self.durationMillis = videoAsset.durationMillis
//      self.frameRate = videoAsset.frameRate
//      self.isKey = videoWindow.keyInfo.isKey
//    }
  }
  
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

//  init(using videoWindow: VideoWindow) {
//    let windowInfo = VideoInfo(using: videoWindow)
//    self.init(using: windowInfo)
//  }
}
