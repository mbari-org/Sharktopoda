//
//  CMTime.swift
//  Created for Sharktopoda on 10/3/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

extension CMTime {
  private static let millisTimescale: CMTimeScale = 1000

  /// Whole milliseconds truncated toward zero. Frame PTS must not round up or ffmpeg
  /// accurate `-ss` will select the next frame.
  var millis: Int {
    Int(value * 1000 / Int64(timescale))
  }

  /// Duration / display-window conversion only. Frame-addressed times use `FrameTiming`.
  static func from(millis: Int, timescale: CMTimeScale) -> CMTime {
    let millisTime = CMTimeMake(value: CMTimeValue(millis), timescale: CMTime.millisTimescale)
    return millisTime.convertScale(timescale, method: .roundTowardZero)
  }
}
