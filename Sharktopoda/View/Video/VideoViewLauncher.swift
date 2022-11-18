//
//  VideoViewLauncher.swift
//  Created for Sharktopoda on 11/17/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct VideoViewLauncher: View {
  @Environment(\.openWindow) private var openWindow
  
  static let launcher = VideoViewLauncher()
  private init() {}
  
  var body: some View {
    Text("CxHidden")
  }

}

extension VideoViewLauncher {
  func open(path: String) {
    open(id: path, url: URL(fileURLWithPath: path))
  }
  
  func open(id: String, url: URL) {
    Task {
      if let videoAsset = await VideoAsset(id: id, url: url) {
        DispatchQueue.main.async {
          UDP.sharktopodaData.videoAssets[id] = videoAsset
//          openWindow(id: id, value: id)
        }
      }
    }
  }
}

//struct VideoViewLauncher_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoViewLauncher()
//    }
//}
