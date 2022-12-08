//
//  CMTime.swift
//  Created for Sharktopoda on 10/3/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

extension CMTime {
  func asMillis() -> Int {
    Int(self.seconds * Double(VideoAsset.timescaleMillis))
  }
  
  static func fromMillis(_ time: Double) -> CMTime {
    fromMillis(Int(time))
  }
  
  static func fromMillis(_ time: Int) -> CMTime {
    CMTimeMake(value: Int64(time), timescale: VideoAsset.timescaleMillis)
  }
}
