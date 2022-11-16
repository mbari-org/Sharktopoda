//
//  VideoView.swift
//  Created for Sharktopoda on 11/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct VideoView: View {
//  @Environment(\.openWindow) var openWindow
  
  @EnvironmentObject var sharktopodaData: SharktopodaData
  @State private var viewIndex: Int? = nil
  
  let id: String
  var keyInfo: KeyInfo = KeyInfo()
  
  var body: some View {
//    if let videoId = videoId {
//      if let index = sharktopodaData.videoWindows
//    }
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

struct VideoView_Previews: PreviewProvider {
  static var previews: some View {
    VideoView(id: "CxDebug")
  }
}
