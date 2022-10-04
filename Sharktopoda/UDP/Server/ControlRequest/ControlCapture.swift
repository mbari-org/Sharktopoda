//
//  ControlCapture.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Network

typealias FrameGrabResult = Result<Int, Error>

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
    let currentTime = videoWindow.elapsedTimeMillis()
    
    guard let fileUrl = URL(string: imageLocation) else {
      return failed("Image location is malformed URL")
    }
    
    guard !FileManager.default.fileExists(atPath: fileUrl.path) else {
      return failed("Image exists at location")
    }
    
    let dirPath = fileUrl.deletingLastPathComponent().path
    guard FileManager.default.isWritableFile(atPath: dirPath) else {
      return failed("Image location not writable")
    }
    
    return ControlResponseCaptureOk(currentTime)
  }
  
  func doCapture(captureTime: Int) async -> ControlResponse {
    guard let videoWindow = UDP.sharktopodaData.videoWindows[uuid] else {
      return ControlResponseCaptureDone(for: self, cause: "Video for uuid was closed")
    }

    switch await videoWindow.frameGrab(at: captureTime, destination: imageLocation) {
      case .success(let grabTime):
        return ControlResponseCaptureDone(for: self, grabTime: grabTime)
      case .failure(let error):
        return ControlResponseCaptureDone(for: self, cause: error.localizedDescription)
    }
  }
}

struct ControlResponseCaptureOk : ControlResponse {
  var response: ControlCommand = .capture
  var status: ControlResponseStatus = .ok
  var captureTime: Int

  init(_ frameTime: Int) {
    self.captureTime = frameTime
  }
}

