//
//  VideoInfo.swift
//  Created for Sharktopoda on 12/1/22.
//
//  Apache License 2.0 — See project LICENSE file
//

struct VideoInfo: Codable {
  var uuid: String
  var url: String
  var durationMillis: Int
  var frameRate: Float
  var isKey: Bool
  
  init(using videoWindow: VideoWindow) {
    let videoAsset = videoWindow.windowData.videoAsset
    self.uuid = videoAsset.id
    self.url = videoAsset.url.absoluteString
    self.durationMillis = videoAsset.durationMillis
    self.frameRate = videoAsset.frameRate
    self.isKey = videoWindow.windowData.windowKeyInfo.isKey
  }
}
