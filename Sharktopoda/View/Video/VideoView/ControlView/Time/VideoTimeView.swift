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
      Text(humanTime(windowData.playerTime))
        .padding(.leading, 5)
        .frame(width: 80)
      
      VideoTimeSlider()
        .frame(height: 20)

      Text(humanTime(windowData.videoAsset.duration - windowData.playerTime))
        .padding(.trailing, 5)
        .frame(width: 80)
    }
  }
  
  func humanTime(_ time: CMTime) -> String {
    let hours = Int(time.seconds / 3600.0)
    let minutes = Int(time.seconds / 60.0) - (hours * 60)
    let seconds = time.seconds - Double(hours * 3600) - Double(minutes * 60)
    
    let hh = String(format: "%02d", hours)
    let mm = String(format: "%02d", minutes)
    let ss = String(format: "%02.0f", seconds)
    return "\(hh):\(mm):\(ss)"
  }
}

struct VideoControlTimeView_Previews: PreviewProvider {
  static var previews: some View {
    VideoTimeView()
      .environmentObject(WindowData())
  }
}
