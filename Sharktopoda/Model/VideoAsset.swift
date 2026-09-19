//
//  VideoAsset.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

// CxNote Binds to first AVAsset video track

final class VideoAsset {
  private static let sampleProbeCount = 48

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
      let (nominalRate, minDuration, naturalTimeScale) =
        try await videoTrack.load(.nominalFrameRate, .minFrameDuration, .naturalTimeScale)
      frameRate = nominalRate

      frameDuration = try Self.resolveFrameDuration(
        asset: avAsset,
        track: videoTrack,
        minFrameDuration: minDuration,
        naturalTimeScale: naturalTimeScale,
        url: url
      )
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

  /// Prefer constant PTS step from decoded sample times; fall back to minFrameDuration only
  /// when samples cannot be read but min duration is a usable positive CFR step.
  private static func resolveFrameDuration(
    asset: AVAsset,
    track: AVAssetTrack,
    minFrameDuration: CMTime,
    naturalTimeScale: CMTimeScale,
    url: URL
  ) throws -> CMTime {
    if let times = try? presentationTimes(asset: asset, track: track, limit: sampleProbeCount),
       times.count >= 2 {
      do {
        return try FrameTiming.resolveFrameDuration(
          presentationTimes: times,
          naturalTimeScale: naturalTimeScale > 0 ? naturalTimeScale : nil
        )
      } catch let error as FrameTimingError {
        throw OpenVideoError.irregularFrameTiming(url, reason: error.reason)
      }
    }

    guard minFrameDuration.isValid,
          !minFrameDuration.isIndefinite,
          minFrameDuration.value > 0,
          minFrameDuration.timescale > 0 else {
      throw OpenVideoError.irregularFrameTiming(
        url,
        reason: "No sample presentation times and invalid minFrameDuration"
      )
    }

    if naturalTimeScale > 0 {
      return minFrameDuration.convertScale(naturalTimeScale, method: .default)
    }
    return minFrameDuration
  }

  private static func presentationTimes(
    asset: AVAsset,
    track: AVAssetTrack,
    limit: Int
  ) throws -> [CMTime] {
    let reader = try AVAssetReader(asset: asset)
    let output = AVAssetReaderTrackOutput(track: track, outputSettings: nil)
    output.alwaysCopiesSampleData = false
    guard reader.canAdd(output) else {
      throw FrameTimingError.sampleReadFailed
    }
    reader.add(output)
    guard reader.startReading() else {
      throw FrameTimingError.sampleReadFailed
    }

    var times: [CMTime] = []
    times.reserveCapacity(limit)
    while times.count < limit {
      guard let sample = output.copyNextSampleBuffer() else { break }
      let pts = CMSampleBufferGetPresentationTimeStamp(sample)
      guard pts.isValid, !pts.isIndefinite else { continue }
      if let last = times.last, CMTimeCompare(pts, last) <= 0 {
        continue
      }
      times.append(pts)
    }

    if reader.status == .failed {
      throw FrameTimingError.sampleReadFailed
    }
    return times
  }
  
  func frameGrab(atFrame frame: Int, destination: String) async -> FrameGrabResult {
    let captureTime = time(ofFrame: frame)
    let imageGenerator = AVAssetImageGenerator(asset: avAsset)
    imageGenerator.requestedTimeToleranceAfter = CMTime.zero
    imageGenerator.requestedTimeToleranceBefore = CMTime.zero
    imageGenerator.apertureMode = .encodedPixels
    imageGenerator.appliesPreferredTrackTransform = true

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

private extension FrameTimingError {
  var reason: String {
    switch self {
    case .insufficientSamples(let count):
      return "need at least 2 presentation timestamps, got \(count)"
    case .nonIncreasingPresentationTime:
      return "non-increasing sample presentation timestamps"
    case .variableFrameRate(let distinct, let majority):
      return "variable frame rate (\(distinct) distinct steps, dominant only \(majority)%)"
    case .sampleReadFailed:
      return "failed reading video samples"
    }
  }
}
