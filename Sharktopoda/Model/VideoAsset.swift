//
//  VideoAsset.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

// CxNote Binds to first AVAsset video track

final class VideoAsset {
  static let timescaleMillis: Int32 = 1000
  
  let id: String
  let url: URL
  
  var avAsset: AVURLAsset

  var avAssetTrack: AVAssetTrack
  var duration: CMTime
  var frameDuration: CMTime
  var frameRate: Float
  var fullSize: NSSize
  var isPlayable: Bool
  
  var durationMillis: Int {
    duration.asMillis()
  }
  
  init(id: String, url: URL) async throws {
    self.id = id
    self.url = url

    avAsset = AVURLAsset(url: url)
    
    do {
      isPlayable = try await avAsset.load(.isPlayable)
      guard isPlayable else {
        throw OpenVideoError.notPlayable(url)
      }

      duration = try await avAsset.load(.duration)
      
      let tracks = try await avAsset.loadTracks(withMediaType: AVMediaType.video)
      guard let track = tracks.first else {
        throw OpenVideoError.noTrack(url)
      }
      avAssetTrack = track
      
      frameDuration = try await track.load(.minFrameDuration)
      frameRate = try await track.load(.nominalFrameRate)

      let trackTransform = try await track.load(.preferredTransform)
      let trackSize = try await track.load(.naturalSize)
      let size = trackSize.applying(trackTransform)
      fullSize = NSMakeSize(abs(size.width), abs(size.height))
    } catch let error {
      throw OpenVideoError.loadProperty(url, error: error)
    }
  }
  
  func frameGrab(at captureTime: Int, destination: String) async -> FrameGrabResult {
    avAsset.frameGrab(at: captureTime, destination: destination)
  }
}
