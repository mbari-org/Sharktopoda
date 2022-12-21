//
//  ControlCapture.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Network

typealias FrameGrabResult = Result<Int, Error>

struct ControlCapture: ControlMessage {
  var command: ControlCommand
  var uuid: String
  var imageLocation: String
  var imageReferenceUuid: String
  
  func process() -> ControlResponse {
    withWindowData(id: uuid) { windowData in
      // CxNote Capture current time to get frame as close to command request as possible.
      let captureTime = windowData.videoControl.currentTime

      let fileUrl = URL(fileURLWithPath: imageLocation)

      guard !FileManager.default.fileExists(atPath: fileUrl.path) else {
        return failed("Image exists at location")
      }

      let dirPath = fileUrl.deletingLastPathComponent().path
      guard FileManager.default.isWritableFile(atPath: dirPath) else {
        return failed("Image location not writable")
      }
      
      Task {
        let captureDoneMessage = await doCapture(captureTime: captureTime)
        if let client = UDP.sharktopodaData.udpClient {
          client.process(captureDoneMessage)
        }
      }

      return ok()
    }
  }
  
  func doCapture(captureTime: Int) async -> ClientMessage {
    guard let videoWindow = UDP.sharktopodaData.window(for: uuid) else {
      return ClientMessageCaptureDone(for: self, cause: "Video for uuid was closed")
    }
    
    let videoAsset = await videoWindow.windowData.videoAsset

    switch await videoAsset.frameGrab(at: captureTime, destination: imageLocation) {
      case .success(let grabTime):
        return ClientMessageCaptureDone(for: self, grabTime: grabTime)

      case .failure(let error):
        return ClientMessageCaptureDone(for: self, cause: error.localizedDescription)
    }
  }
}
