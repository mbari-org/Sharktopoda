//
//  VideoAsset.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import AVFoundation

// CxNote Assume that a VideoAsset has one and only one track

struct VideoAsset {
  let uuid: String
  let url: URL
  
  var avAsset: AVAsset
  var avAssetTrack: AVAssetTrack?
  
  var localizations: [Localization] = []

  init(uuid: String, url: URL) {
    self.uuid = uuid
    self.url = url
    avAsset = AVAsset(url: url)
    avAssetTrack = avAsset.tracks(withMediaType: AVMediaType.video).first
  }

  var size: NSSize? {
    guard let track = avAssetTrack else { return nil }
    let size = track.naturalSize.applying(track.preferredTransform)
    return NSMakeSize(abs(size.width), abs(size.height))
  }
  
  var durationMillis: Int {
    Int(CMTimeGetSeconds(avAsset.duration) * 1000)
  }
  
  var frameRate: Float {
    guard let track = avAssetTrack else { return Float(0) }
    return track.nominalFrameRate
  }
}
