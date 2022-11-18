//
//  VideoView.swift
//  Created for Sharktopoda on 11/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct VideoView: View {
//  @Environment(\.openWindow) var openWindow
//  @EnvironmentObject var sharktopodaData: SharktopodaData
//  private var sharktopodaData: SharktopodaData?
  
  private var videoAsset: VideoAsset
  var keyInfo: KeyInfo = KeyInfo()
  
  init(id: String, model: SharktopodaData) {
    videoAsset = model.videoAssets[id]!
  }
  
  var body: some View {
    Text("Yes")
  }
}

struct VideoView_Previews: PreviewProvider {
  static var previews: some View {
//    VideoView(id: "CxDebug").environmentObject(SharktopodaData())
    VideoView(id: "CxDebug", model: SharktopodaData())
  }
}
