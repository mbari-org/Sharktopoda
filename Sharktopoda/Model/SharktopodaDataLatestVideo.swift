//
//  SharktopodaDataLatestVideo.swift
//  Created for Sharktopoda on 12/22/22.
//
//  Apache License 2.0 — See project LICENSE file
//

/// Latest Video Window is based on KeyInfo time

extension SharktopodaData {
  func close(id: String) {
    guard let videoWindow = videoWindows[id] else { return }
    
    videoWindow.close()
  }
  
  func releaseWindow(_ videoWindow: VideoWindow) {
    let id = videoWindow.id
    videoWindows.removeValue(forKey: id)

    let nextLatest = latestVideoWindow()

    Task {
      await openVideos.close(id: id)

      if let latestVideoWindow = nextLatest {
        await latestVideoWindow.bringToFront()
      } else {
        await mainViewWindow?.deminiaturize(nil)
      }
    }
  }
  
  func latestVideoWindow() -> VideoWindow? {
    guard !videoWindows.isEmpty else { return nil }
    
    let windows: [VideoWindow] = Array(videoWindows.values)
    
    if let videoWindow = windows.first(where: \.windowData.windowKeyInfo.isKey) {
      return videoWindow
    }
    
    return windows.sorted(by: { $0.windowData < $1.windowData }).last
  }
}

