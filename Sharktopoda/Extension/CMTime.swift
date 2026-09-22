//
//  CMTime.swift
//  Created for Sharktopoda on 10/3/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

extension CMTime {
  private static let millisTimescale: CMTimeScale = 1000

  var millis: Int {
    Int(value * 1000 / Int64(timescale))
  }

  /// Duration / display-window conversion only. Frame-addressed times use `FrameTiming`.
  static func from(millis: Int, timescale: CMTimeScale) -> CMTime {
    let millisTime = CMTimeMake(value: CMTimeValue(millis), timescale: CMTime.millisTimescale)
    return millisTime.convertScale(timescale, method: .roundTowardZero)
  }

  var humanTime: String {
    let hours = Int(seconds / 3600.0)
    let minutes = Int(seconds / 60.0) - (hours * 60)
    let secs = seconds - Double(hours * 3600) - Double(minutes * 60)

    let hh = String(format: "%02d", hours)
    let mm = String(format: "%02d", minutes)
    let ss = String(format: "%02d", Int(secs))
    return "\(hh):\(mm):\(ss)"
  }
}
