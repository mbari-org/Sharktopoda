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
    
    if let errorMessage = VideoWindow.open(id: uuid, url: url) {
      return failed(errorMessage)
    }
    return ok()
  }
}
