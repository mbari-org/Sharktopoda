//
//  ControlResponseInfo.swift
//  Created for Sharktopoda on 9/30/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlResponseInfo: ControlResponse {
  struct WindowInfo {
    var uuid: String
    var url: String
    var durationMillis: Int
    var frameRate: Float
    var isKey: Bool
    
    init(from videoWindow: VideoWindow) {
      let videoAsset = videoWindow.videoView.videoAsset
      self.uuid = videoAsset.uuid
      self.url = videoAsset.url.absoluteString
      self.durationMillis = videoAsset.durationMillis
      self.frameRate = round(videoAsset.frameRate * 100) / 100.0
      self.isKey = videoWindow.keyInfo.isKey
    }
  }
  
  var response: ControlCommand
  var status: ControlResponseStatus

  var uuid: String?
  var url: String?
  var durationMillis: Int?
  var frameRate: Float?
  var isKey: Bool?
  
  init(from windowInfo: WindowInfo) {
    response = .info
    status = .ok
    self.uuid = windowInfo.uuid
    self.url = windowInfo.url
    self.durationMillis = windowInfo.durationMillis
    self.frameRate = windowInfo.frameRate
    self.isKey = windowInfo.isKey
  }

  init(from videoWindow: VideoWindow) {
    let windowInfo = WindowInfo(from: videoWindow)
    self.init(from: windowInfo)
  }
}
