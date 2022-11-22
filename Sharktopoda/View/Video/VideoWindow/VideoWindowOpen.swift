//
//  VideoWindowOpen.swift
//  Created for Sharktopoda on 11/22/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

extension VideoWindow {
  static func open(id: String, url: URL, alert: Bool = false) {
    Task {
      if let videoAsset = await VideoAsset(id: id, url: url) {
        DispatchQueue.main.async {
          UDP.sharktopodaData.tmpVideoAssets[id] = videoAsset
          if let error = VideoWindow.open(videoId: id) as? OpenVideoError {
            UDP.log("Open \(url.absoluteString) error: \(error.debugDescription)")
            if alert {
              let openAlert = OpenAlert(path: url.absoluteString, error: error)
              openAlert.show()
            }
          }
        }
      }
    }
  }
  
  static func open(url: URL) {
    open(id: url.path, url: url, alert: true)
  }
  
  private static func open(videoId: String) -> Error? {
    if let videoWindow = UDP.sharktopodaData.videoWindows[videoId] {
      DispatchQueue.main.async {
        videoWindow.makeKeyAndOrderFront(nil)
      }
    } else {
      guard let videoAsset = UDP.sharktopodaData.tmpVideoAssets[videoId] else {
        return OpenVideoError.notLoaded
      }
      
      guard videoAsset.isPlayable else {
        return OpenVideoError.notPlayable
      }
      
      UDP.sharktopodaData.tmpVideoAssets[videoId] = nil
      
      DispatchQueue.main.async {
        let videoWindow = VideoWindow(for: videoAsset)
        videoWindow.makeKeyAndOrderFront(nil)
        UDP.sharktopodaData.videoWindows[videoId] = videoWindow
      }
    }
    return nil
  }
}
