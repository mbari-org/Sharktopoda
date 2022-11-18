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

    /// Fire and forget async operation
    VideoViewLauncher.launcher.open(id: uuid, url: url)
//    UDP.sharktopodaData.open(id: uuid, url: url)

    return ok()
  }
}
