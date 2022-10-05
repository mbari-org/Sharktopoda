//
//  ControlOpen.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import AppKit
import AVFoundation

struct ControlOpen: ControlRequest {
  var command: ControlCommand
  var uuid: String
  var url: String
  
  var description: String {
    "\(command) \(uuid) from \(url)"
  }
  
  func process() -> ControlResponse {
    guard let url = URL(string: url) else {
      return failed("Malformed URL")
    }

    do {
      if !(try url.checkResourceIsReachable()) {
        return failed("Video file not reachable")
      }
    } catch let error {
      return failed(error.localizedDescription)
    }
    
    if let videoWindow = UDP.sharktopodaData.videoWindows[uuid] {
      DispatchQueue.main.async {
        videoWindow.makeKeyAndOrderFront(nil)
      }
    } else {
      let videoAsset = VideoAsset(uuid: uuid, url: url)
      guard videoAsset.avAsset.isPlayable else {
        return failed("URL not playable")
      }
      DispatchQueue.main.async {
        let videoWindow = VideoWindow(for: videoAsset)
        videoWindow.makeKeyAndOrderFront(nil)
        UDP.sharktopodaData.videoWindows[uuid] = videoWindow
      }
    }
    return ok()
  }
}
