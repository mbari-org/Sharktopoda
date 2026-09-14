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
      // Snapshot frame identity immediately so capture matches what was on screen.
      let captureFrame = windowData.videoControl.currentFrame

      let fileUrl = URL(fileURLWithPath: imageLocation)

      guard !FileManager.default.fileExists(atPath: fileUrl.path) else {
        return failed("Image exists at location")
      }

      let dirPath = fileUrl.deletingLastPathComponent().path
      guard FileManager.default.isWritableFile(atPath: dirPath) else {
        return failed("Image location not writable")
      }
      
      Task {
        let captureDoneMessage = await doCapture(frame: captureFrame)
        if let client = UDP.sharktopodaData.udpClient {
          client.process(captureDoneMessage)
        }
      }

      return ok()
    }
  }
  
  func doCapture(frame: Int) async -> ClientMessage {
    guard let videoWindow = UDP.sharktopodaData.window(for: uuid) else {
      return ClientMessageCaptureDone(for: self, cause: "Video for uuid was closed")
    }
    
    let videoAsset = await videoWindow.windowData.videoAsset

    switch await videoAsset.frameGrab(atFrame: frame, destination: imageLocation) {
      case .success(let grabTime):
        return ClientMessageCaptureDone(for: self, grabTime: grabTime)

      case .failure(let error):
        return ClientMessageCaptureDone(for: self, cause: error.localizedDescription)
    }
  }
}
