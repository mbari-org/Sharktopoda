//
//  VideoAsset.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

// CxNote Binds to first AVAsset video track

final class VideoAsset {
  let id: String
  let url: URL
  
  var avAsset: AVURLAsset

  var duration: CMTime
  var frameDuration: CMTime
  var frameRate: Float
  var fullSize: NSSize
  let frameTiming: FrameTiming
  
  var timescale: CMTimeScale {
    frameDuration.timescale
  }

  var lastFrame: Int {
    frameTiming.lastFrame(duration: duration)
  }

  func frame(forMillis ms: Int) -> Int {
    frameTiming.frame(forMillis: ms)
  }

  func frame(displayedAt time: CMTime) -> Int {
    frameTiming.frame(displayedAt: time)
  }

  func time(ofFrame frame: Int) -> CMTime {
    frameTiming.time(ofFrame: frame)
  }

  func millis(ofFrame frame: Int) -> Int {
    frameTiming.millis(ofFrame: frame)
  }
  
  init(id: String, url: URL) async throws {
    self.id = id
    self.url = url
    
    do {
      avAsset = AVURLAsset(url: url)
      
      let videoTracks = try await avAsset.loadTracks(withMediaType: .video)
      guard let videoTrack = videoTracks.first else {
        throw OpenVideoError.noVideo(url)
      }
      
      guard try await videoTrack.load(.isPlayable) else {
        throw OpenVideoError.notPlayable(url)
      }

      let trackStart = try await videoTrack.load(.timeRange).start
      guard trackStart == .zero else {
        throw OpenVideoError.nonZeroStart(url, start: trackStart)
      }

      duration = try await avAsset.load(.duration)
      (frameRate, frameDuration) = try await videoTrack.load(.nominalFrameRate, .minFrameDuration)
      frameTiming = FrameTiming(frameDuration: frameDuration)
      
      let (videoPreferredTransform, videoNaturalSize) =
        try await videoTrack.load(.preferredTransform, .naturalSize)

      let size = videoNaturalSize.applying(videoPreferredTransform)
      fullSize = NSMakeSize(abs(size.width), abs(size.height))
    } catch let error as OpenVideoError {
      throw error
    } catch let error {
      throw OpenVideoError.loadProperty(url, error: error)
    }
  }
  
  func frameGrab(atFrame frame: Int, destination: String) async -> FrameGrabResult {
    let captureTime = time(ofFrame: frame)
    let imageGenerator = AVAssetImageGenerator(asset: avAsset)
    imageGenerator.requestedTimeToleranceAfter = CMTime.zero
    imageGenerator.requestedTimeToleranceBefore = CMTime.zero

    do {
      let (cgImage, actualTime) = try await imageGenerator.image(at: captureTime)
      guard actualTime == captureTime else {
        return .failure(FrameCaptureError.unexpectedActualTime(requested: captureTime, actual: actualTime))
      }
      if let error = cgImage.pngWrite(to: destination) {
        return .failure(error)
      }
      return .success(millis(ofFrame: frame))
    } catch(let error) {
      return .failure(error)
    }
  }
}
