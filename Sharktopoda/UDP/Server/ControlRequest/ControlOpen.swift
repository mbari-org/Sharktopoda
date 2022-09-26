//
//  ControlOpen.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import AppKit


struct ControlOpen: ControlRequest {
  var command: ControlCommand
  var uuid: String
  var url: String
  
  var description: String {
    "\(command) \(uuid) from \(url)"
  }
  
  func process() -> ControlResponse {
    guard let urlRef = URL(string: url) else {
      return ControlResponseCommand.failed(command, cause: "Malformed URL")
    }
    UDP.log("ControlOpen \(urlRef.absoluteString)")
    
    if let videoView = UDP.sharktopodaData.videoViews[uuid] {
      UDP.log("bring forward video view \(videoView.videoAsset.uuid)")
    } else {
      DispatchQueue.main.async {
        let videoView = VideoView(videoAsset: VideoAsset(uuid: uuid))
        UDP.sharktopodaData.videoViews[uuid] = videoView
        videoView.openWindow()
      }
    }
    
    return ControlResponseCommand.ok(command)
  }
}
