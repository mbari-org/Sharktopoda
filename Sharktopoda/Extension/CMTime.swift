//
//  CMTime.swift
//  Created for Sharktopoda on 10/3/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

extension CMTime {
  private static let millisTimescale: CMTimeScale = 1000
  private static let millisScaleFactor = Double(millisTimescale)
  
  var millis: Int {
    Int(round(seconds * CMTime.millisScaleFactor))
  }
    
  static func from(millis: Int, timescale: CMTimeScale) -> CMTime {
    let millisTime = CMTimeMake(value: CMTimeValue(millis), timescale: CMTime.millisTimescale)
    return millisTime.convertScale(timescale, method: .roundTowardZero)

  }
}
