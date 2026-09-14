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
struct FrameTiming {
  let frameDuration: CMTime

  init(frameDuration: CMTime) {
    precondition(frameDuration.isValid && !frameDuration.isIndefinite)
    precondition(frameDuration.value > 0 && frameDuration.timescale > 0)
    self.frameDuration = frameDuration
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
