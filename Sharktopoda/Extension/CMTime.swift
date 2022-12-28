//
//  CMTime.swift
//  Created for Sharktopoda on 10/3/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

extension CMTime {
  func asMillis() -> Int {
    Int(seconds * Double(VideoAsset.timescaleMillis))
  }
  
  static func fromMillis(_ time: Double) -> CMTime {
    guard !time.isNaN,
          !time.isInfinite else { return .zero }
    
    return fromMillis(Int(time))
  }
  
  static func fromMillis(_ time: Int) -> CMTime {
    CMTimeMake(value: Int64(time), timescale: VideoAsset.timescaleMillis)
  }
}
