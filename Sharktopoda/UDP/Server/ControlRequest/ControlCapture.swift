//
//  ControlCapture.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlCapture: ControlRequest {
  var command: ControlCommand
  var uuid: String
  var imageLocation: String
  var imageReferenceUuid: String
  
  func process() -> ControlResponse {
    print("CxInc handle: \(self)")
    return ok()
  }
}