//
//  VideoTimeView
//  Created for Sharktopoda on 11/29/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import SwiftUI

struct VideoTimeView: View {
  @EnvironmentObject var windowData: WindowData
  
  var body: some View {
    HStack {
      Text(windowData.playerTime.humanTime)
        .padding(.leading, 5)
        .frame(width: 80)

      VideoTimeSlider()
        .frame(height: 20)

      Text((windowData.videoAsset.duration - windowData.playerTime).humanTime)
        .padding(.trailing, 5)
        .frame(width: 80)
    }
  }
}

struct VideoControlTimeView_Previews: PreviewProvider {
  static var previews: some View {
    VideoTimeView()
      .environmentObject(WindowData())
  }
}
