//
//  VideoAsset.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

// CxNote Binds to first AVAsset video track

final class VideoAsset: Identifiable, ObservableObject {
  static let timescaleMillis: Int32 = 1000
  
  let id: String
  let url: URL
  
  var avAsset: AVURLAsset

  var avAssetTrack: AVAssetTrack
  var durationMillis: Int
  var frameDuration: CMTime
  var frameRate: Float
  var fullSize: NSSize
  
  var localizations: Localizations?
  
  init?(id: String, url: URL) async {
    self.id = id
    self.url = url

    avAsset = AVURLAsset(url: url)
    
    do {
      let duration = try await avAsset.load(.duration)
      durationMillis = duration.asMillis()
      
      let tracks = try await avAsset.loadTracks(withMediaType: AVMediaType.video)
      guard let track = tracks.first else { return nil }
      
      frameDuration = try await track.load(.minFrameDuration)
      frameRate = try await track.load(.nominalFrameRate)

      let trackTransform = try await track.load(.preferredTransform)
      let trackSize = try await track.load(.naturalSize)
      let size = trackSize.applying(trackTransform)
      fullSize = NSMakeSize(abs(size.width), abs(size.height))
      
      self.avAssetTrack = track
      
      localizations = Localizations(videoAsset: self,
                                    frameDuration: frameDuration.asMillis())

    } catch let error {
      print("CxInc VideoAsset error: \(error)")
      return nil
    }
  }
  
  func frameGrab(at captureTime: Int, destination: String) async -> FrameGrabResult {
    avAsset.frameGrab(at: captureTime, destination: destination)
  }
}
