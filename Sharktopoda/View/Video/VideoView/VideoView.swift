//
//  VideoView.swift
//  Created for Sharktopoda on 11/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import SwiftUI

struct VideoView: View {
//  @Environment(\.openWindow) var openWindow
//  @EnvironmentObject var sharktopodaData: SharktopodaData
//  private var sharktopodaData: SharktopodaData?

  
  var sharktopodaData: SharktopodaData
  var videoAsset: VideoAsset
  var keyInfo: KeyInfo = KeyInfo()
  
  init(_ model: SharktopodaData, videoId: String) {
    videoAsset = model.videoAssets[videoId]!
    sharktopodaData = model
  }

  var body: some View {
    VStack {
      PlayerView(videoAsset: videoAsset)
        .padding(0)
      Divider()
      VideoControlView()
        .environmentObject(sharktopodaData)
        .padding(0)
    }
  }
}

struct VideoView_Previews: PreviewProvider {
  static var previews: some View {
//    VideoView(id: "CxDebug").environmentObject(SharktopodaData())
    VideoView(SharktopodaData(), videoId: "CxDebug")
  }
}
