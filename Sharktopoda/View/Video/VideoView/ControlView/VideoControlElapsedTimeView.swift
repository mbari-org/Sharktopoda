//
//  VideoControlElapsedTimeView.swift
//  Created for Sharktopoda on 11/29/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct VideoControlElapsedTimeView: View {
  @EnvironmentObject var windowData: WindowData
  
  var body: some View {
    Text(String(windowData.playerTime))
      .padding(.leading, 10)
      .padding(.trailing, 10)
  }
}

struct VideoControlElapsedTimeView_Previews: PreviewProvider {
  static var previews: some View {
    VideoControlElapsedTimeView()
  }
}
