//
//  FrameTiming.swift
//  Created for Sharktopoda.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

/// Maps between elapsed milliseconds and constant-frame-rate presentation times.
///
/// Wire contract matches ffmpeg accurate `-ss` before `-i`:
/// `elapsedTimeMillis` identifies the first frame whose PTS is ≥ that value (ceil).
/// Emitted millis are a frame PTS truncated to whole milliseconds.
///
/// Frame duration is the constant PTS step (sample delta), not merely `minFrameDuration`.
struct FrameTiming {
  let frameDuration: CMTime

  init(frameDuration: CMTime) {
    precondition(frameDuration.isValid && !frameDuration.isIndefinite)
    precondition(frameDuration.value > 0 && frameDuration.timescale > 0)
    self.frameDuration = frameDuration
  }

  /// Builds timing from ordered sample presentation timestamps (CFR).
  static func from(presentationTimes: [CMTime], naturalTimeScale: CMTimeScale? = nil) throws -> FrameTiming {
    let duration = try Self.resolveFrameDuration(
      presentationTimes: presentationTimes,
      naturalTimeScale: naturalTimeScale
    )
    return FrameTiming(frameDuration: duration)
  }

  static func resolveFrameDuration(
    presentationTimes: [CMTime],
    naturalTimeScale: CMTimeScale? = nil
  ) throws -> CMTime {
    guard presentationTimes.count >= 2 else {
      throw FrameTimingError.insufficientSamples(presentationTimes.count)
    }

    var deltas: [CMTime] = []
    deltas.reserveCapacity(presentationTimes.count - 1)
    for i in 1..<presentationTimes.count {
      let delta = CMTimeSubtract(presentationTimes[i], presentationTimes[i - 1])
      guard delta.isValid, !delta.isIndefinite, delta.value > 0 else {
        throw FrameTimingError.nonIncreasingPresentationTime
      }
      deltas.append(delta)
    }

    let targetScale = preferredTimescale(deltas: deltas, naturalTimeScale: naturalTimeScale)
    var counts: [CMTimeValue: Int] = [:]
    for delta in deltas {
      let normalized = delta.convertScale(targetScale, method: .default)
      guard normalized.isValid, normalized.value > 0 else {
        throw FrameTimingError.nonIncreasingPresentationTime
      }
      counts[normalized.value, default: 0] += 1
    }

    guard let (bestValue, bestCount) = counts.max(by: { $0.value < $1.value }) else {
      throw FrameTimingError.insufficientSamples(presentationTimes.count)
    }

    let majorityBasis = (bestCount * 100) / deltas.count
    guard majorityBasis >= 80 else {
      throw FrameTimingError.variableFrameRate(distinctSteps: counts.count, majorityPercent: majorityBasis)
    }

    return CMTime(value: bestValue, timescale: targetScale)
  }

  private static func preferredTimescale(deltas: [CMTime], naturalTimeScale: CMTimeScale?) -> CMTimeScale {
    if let naturalTimeScale, naturalTimeScale > 0 {
      return naturalTimeScale
    }
    return deltas.map(\.timescale).max() ?? 600
  }

  func frame(forMillis ms: Int) -> Int {
    precondition(ms >= 0)
    let duration = Int64(frameDuration.value)
    let ts = Int64(frameDuration.timescale)
    return Int((Int64(ms) * ts + 1000 * duration - 1) / (1000 * duration))
  }

  func frame(displayedAt time: CMTime) -> Int {
    guard time > .zero else { return 0 }
    let ticks = time.convertScale(frameDuration.timescale, method: .roundHalfAwayFromZero).value
    return Int(max(0, ticks) / frameDuration.value)
  }

  func time(ofFrame frame: Int) -> CMTime {
    precondition(frame >= 0)
    return CMTimeMultiply(frameDuration, multiplier: Int32(frame))
  }

  func millis(ofFrame frame: Int) -> Int {
    precondition(frame >= 0)
    return Int(Int64(frame) * Int64(frameDuration.value) * 1000 / Int64(frameDuration.timescale))
  }

  func lastFrame(duration: CMTime) -> Int {
    frame(displayedAt: duration)
  }
}

enum FrameTimingError: Error, Equatable {
  case insufficientSamples(Int)
  case nonIncreasingPresentationTime
  case variableFrameRate(distinctSteps: Int, majorityPercent: Int)
  case sampleReadFailed
}
