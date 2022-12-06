//
//  VideoWindowOpen.swift
//  Created for Sharktopoda on 11/22/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

extension VideoWindow {
  static func onMain(_ fn: @escaping () -> Void) {
    DispatchQueue.main.async { fn() }
  }
  
  static func open(url: URL) {
    open(id: url.path, url: url, alert: true)
  }
  
  static func open(id: String, url: URL, alert: Bool = false) {
    if let videoWindow = UDP.sharktopodaData.videoWindows[id] {
      onMain {
        videoWindow.bringToFront()
      }
    } else {
      Task {
        do {
          let videoAsset = try await VideoAsset(id: id, url: url)
          let videoWindow = VideoWindow(for: videoAsset, with: UDP.sharktopodaData)
          UDP.sharktopodaData.videoWindows[videoAsset.id] = videoWindow
          onMain {
            videoWindow.windowData.sliderView.setupControlViewAnimation()
            videoWindow.bringToFront()
          }
          
          if let client = UDP.sharktopodaData.udpClient {
            let openDoneMessage = ClientMessageOpenDone(uuid: id)
            client.process(openDoneMessage)
          }
        } catch {
          guard let openVideoError = error as? OpenVideoError else {
            UDP.log(error.localizedDescription)
            return
          }
          UDP.log(openVideoError.description)
          onMain { OpenAlert(path: url.absoluteString, error: openVideoError).show() }
        }
      }
    }
  }
}
