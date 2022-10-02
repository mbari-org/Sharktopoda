//
//  ControlCapture.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Network

struct ControlCapture: ControlRequest {
  var command: ControlCommand
  var uuid: String
  var imageLocation: String
  var imageReferenceUuid: String
  
  static let saveImageQueue = DispatchQueue(label: "save image queue")
  
  func process() -> ControlResponse {
    guard let videoWindow = UDP.sharktopodaData.videoWindows[uuid] else {
      return failed("No video for uuid")
    }
    // CxNote Immediately capture current time to get frame as close to command request
    // as possible. We put this time in the ControlResponse so it can be used later during
    // image capture processing. This means the time is sent in the initial 'ok' response but
    // the command contoller can just ignore it.
    let currentTime = videoWindow.elapsed()
    
    let fileUrl = URL(fileURLWithPath: imageLocation)
    do {
      if try fileUrl.checkResourceIsReachable() {
        return failed("Image exists")
      }
    } catch let error {
      return failed(error.localizedDescription)
    }
    return ControlResponseCaptureOk(currentTime)
  }
  
  func doCapture(captureTime: Int) async -> ControlResponse {
    guard let videoWindow = UDP.sharktopodaData.videoWindows[uuid] else {
      return failed("No video for uuid")
    }
    let fileUrl = URL(fileURLWithPath: imageLocation)
    let (grabTime, error) = await videoWindow.frameGrab(at: captureTime, destination: fileUrl)
    if let grabTime = grabTime {
      return ControlResponseCaptureDone(for: self, grabTime: grabTime)
    } else {
      return ControlResponseCaptureDone(for: self, cause: error!)
    }
  }
}

struct ControlResponseCaptureOk : ControlResponse {
  var response: ControlCommand = .capture
  var status: ControlResponseStatus = .ok
  var elapsedTimeMillis: Int

  init(_ frameTime: Int) {
    self.elapsedTimeMillis = frameTime
  }
}

