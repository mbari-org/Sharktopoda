//
//  ControlResponseCapture.swift
//  Created for Sharktopoda on 10/1/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlResponseCaptureDone: ControlResponse {
  var response: ControlCommand
  var status: ControlResponseStatus

  var uuid: String
  var imageLocation: String
  var imageReferenceUuid: String
  var elapsedTimeMillis: Int?
  var cause: String?
  
  init(for controlCapture: ControlCapture) {
    response = .captureDone
    status = .ok
    
    uuid = controlCapture.uuid
    imageLocation = controlCapture.imageLocation
    imageReferenceUuid = controlCapture.imageReferenceUuid
  }
  
  init(for controlCapture: ControlCapture, grabTime: Int) {
    self.init(for: controlCapture)
    elapsedTimeMillis = grabTime
  }
  
  init(for controlCapture: ControlCapture, cause: String) {
    self.init(for: controlCapture)
    status = .failed
    self.cause = cause
  }
}
