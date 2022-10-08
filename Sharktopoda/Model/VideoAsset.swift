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
  
  var localizations = Localizations()
  
  static let timescaleMillis: Int32 = 1000
  
  init(id: String, url: URL) {
    self.id = id
    self.url = url
    avAsset = AVURLAsset(url: url)
    avAssetTrack = avAsset.tracks(withMediaType: AVMediaType.video).first
  }
  
  var durationMillis: Int {
    avAsset.duration.asMillis()
  }
  
  var frameDurataionMillis: Int {
    guard let track = avAssetTrack else { return 0 }
    return track.minFrameDuration.asMillis()
  }
  
  func frameGrab(at captureTime: Int, destination: String) async -> FrameGrabResult {
    avAsset.frameGrab(at: captureTime, destination: destination)
  }
  
  var frameRate: Float {
    guard let track = avAssetTrack else { return Float(0) }
    return track.nominalFrameRate
  }
  
  var size: NSSize? {
    guard let track = avAssetTrack else { return nil }
    let size = track.naturalSize.applying(track.preferredTransform)
    return NSMakeSize(abs(size.width), abs(size.height))
  }
}

// Localizations
extension VideoAsset {
  
  mutating func addLocalizations(_ newLocalizations: [Localization]) -> [Bool] {
    newLocalizations.map { localization in
      localizations.add(localization)
    }
  }
  
  mutating func removeLocalizations(_ localizationIds: [String]) -> [Bool] {
    localizationIds.map { id in
      localizations.remove(id: id)
    }
  }

  mutating func updateLocalizations(_ updatedLocalizations: [Localization]) -> [Bool] {
    updatedLocalizations.map { localization in
      localizations.update(localization)
    }
  }
}


