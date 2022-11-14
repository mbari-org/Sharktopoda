//
//  VideoAsset.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

// CxNote Assume that a VideoAsset has one and only one track

struct VideoAsset {
  let id: String
  let url: URL
  
  var avAsset: AVURLAsset
  var avAssetTrack: AVAssetTrack?

  let durationMillis: Int
  
  static let timescaleMillis: Int32 = 1000
  
  init(id: String, url: URL) {
    self.id = id
    self.url = url
    avAsset = AVURLAsset(url: url)
    avAssetTrack = avAsset.tracks(withMediaType: AVMediaType.video).first
    
    durationMillis = avAsset.duration.asMillis()
  }
  
  var frameDuration: CMTime {
    avAssetTrack?.minFrameDuration ?? .zero
  }
  
  func frameGrab(at captureTime: Int, destination: String) async -> FrameGrabResult {
    avAsset.frameGrab(at: captureTime, destination: destination)
  }
  
  var frameRate: Float {
    avAssetTrack?.nominalFrameRate ?? 0
  }
  
  var size: NSSize? {
    guard let track = avAssetTrack else { return nil }
    let size = track.naturalSize.applying(track.preferredTransform)
    return NSMakeSize(abs(size.width), abs(size.height))
  }
}
