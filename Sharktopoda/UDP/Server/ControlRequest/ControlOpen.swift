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

  func process() -> ControlResponse {
    guard let url = URL(string: url) else {
      return failed("Malformed URL")
    }

    /// Async load URL, then fire up the VideoView
    Task {
      if let videoAsset = await VideoAsset(id: uuid, url: url) {
        DispatchQueue.main.async {
          UDP.sharktopodaData.tmpVideoAssets[uuid] = videoAsset
          let error = VideoWindow.open(id: uuid)
          if error != nil {
            print("ControlOpen error: \(error.debugDescription)")
          }
          print("Video URL loaded")
        }
      }
    }
    return ok()
  }
}
