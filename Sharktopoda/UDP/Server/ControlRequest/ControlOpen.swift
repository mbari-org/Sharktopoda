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
    
    if let videoWindow = UDP.sharktopodaData.videoWindows[uuid] {
      DispatchQueue.main.async {
        videoWindow.orderFrontRegardless()
      }
    } else {
      DispatchQueue.main.async {
        UDP.sharktopodaData.videoWindows[uuid] = VideoWindow(for: VideoAsset(uuid: uuid))
      }
    }
    
    return ControlResponseCommand.ok(command)
  }
}
