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

  let frameDurataionMillis: Int
  let durationMillis: Int
  
  var orderedLocalizations = OrderedLocalizations()
  
  static let timescaleMillis: Int32 = 1000
  
  init(id: String, url: URL) {
    self.id = id
    self.url = url
    avAsset = AVURLAsset(url: url)
    avAssetTrack = avAsset.tracks(withMediaType: AVMediaType.video).first
    
    frameDurataionMillis = avAssetTrack?.minFrameDuration.asMillis() ?? 0
    durationMillis = avAsset.duration.asMillis()
  }
  
  func frameGrab(at captureTime: Int, destination: String) async -> FrameGrabResult {
    avAsset.frameGrab(at: captureTime, destination: destination)
  }
  
  var frameRate: Float {
    avAssetTrack?.nominalFrameRate ?? 0
  }
  
//  func frameNumber(for elapsedTime: Int) -> Int {
//    (elapsedTime - 1) / frameDurataionMillis + 1
//  }
  
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
      orderedLocalizations.add(localization)
    }
  }
  
  mutating func clearLocalizations() {
    orderedLocalizations.clear()
  }
  
  func localizations(at elapsedTime: Int,
                     for duration: Int,
                     stepping direction: OrderedLocalizations.Step) -> [Localization] {
    orderedLocalizations.localizations(at: elapsedTime, for: duration, stepping: direction)
  }
  
  mutating func removeLocalizations(_ localizationIds: [String]) -> [Bool] {
    localizationIds.map { id in
      orderedLocalizations.remove(id: id)
    }
  }
  
  func selectedLocalizations() -> [Localization] {
    orderedLocalizations.allSelected()
  }

  mutating func selectLocalizations(_ localizationIds: [String]) -> [Bool] {
    orderedLocalizations.clearSelected()

    return localizationIds.map { id in
      orderedLocalizations.select(id)
    }
  }

  mutating func updateLocalizations(_ updatedLocalizations: [Localization]) -> [Bool] {
    updatedLocalizations.map { localization in
      orderedLocalizations.update(localization)
    }
  }
}


