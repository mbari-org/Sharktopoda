//
//  AVAsset.swift
//  Created for Sharktopoda on 10/3/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

extension AVAsset {
  func frameGrab(at captureTime: Int, destination: String) -> FrameGrabResult {
    let frameTime = CMTime.fromMillis(captureTime)
    let imageUrl = URL(fileURLWithPath: destination)
    
    let imageGenerator = AVAssetImageGenerator(asset: self)
    imageGenerator.requestedTimeToleranceAfter = CMTime.zero
    imageGenerator.requestedTimeToleranceBefore = CMTime.zero
    
    var grabTime: CMTime = .indefinite
    do {
      let cgImage = try imageGenerator.copyCGImage(at: frameTime, actualTime: &grabTime)
      if let error = cgImage.pngWrite(to: imageUrl) {
        return .failure(error)
      } else {
        return .success(grabTime.asMillis())
      }
    } catch {
      return .failure(error)
    }
  }
}
