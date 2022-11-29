//
//  VideoControlTimeView.swift
//  Created for Sharktopoda on 11/29/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct VideoControlTimeView: View {
  @EnvironmentObject var windowData: WindowData
  
  var body: some View {
    HStack {
      Text(String(windowData.playerTime))
        .padding(.leading, 5)
        .frame(width: 80)
      
      VideoControlSliderView()

      Text(String(windowData.videoAsset.durationMillis - windowData.playerTime))
        .padding(.trailing, 5)
        .frame(width: 80)
    }
    .frame(maxHeight: 20)
  }
}

struct VideoControlTimeView_Previews: PreviewProvider {
  static var previews: some View {
    VideoControlTimeView()
      .environmentObject(WindowData())
  }
}
