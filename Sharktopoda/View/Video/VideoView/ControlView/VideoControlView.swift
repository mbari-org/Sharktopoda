//
//  VideoControlView.swift
//  Created for Sharktopoda on 11/18/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct VideoControlView: View {
  @EnvironmentObject var windowData: WindowData
  
  var playerDirection: WindowData.PlayerDirection {
    windowData.playerDirection
  }
  
  var previousDirection: WindowData.PlayerDirection {
    windowData.videoControl.previousDirection
  }
  
  var body: some View {
    VStack {
      VideoControlTimeView()
      HStack {
        Toggle("  Show Annotations", isOn: $windowData.showLocalizations)
          .toggleStyle(.checkbox)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 90)
        VideoControlPlayButtons()
          .frame(maxWidth: .infinity, alignment: .center)
        VolumeControlView()
          .frame(maxWidth: .infinity, alignment: .trailing)
          .padding(.trailing, 90)
      }
    }
  }
}

//struct VideoControlView_Previews: PreviewProvider {
//  static var previews: some View {
//    VideoControlView().environmentObject(WindowData())
//  }
//}
