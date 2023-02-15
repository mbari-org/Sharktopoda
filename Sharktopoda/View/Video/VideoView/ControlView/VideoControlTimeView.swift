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
      Text(humanTime(windowData.playerTime))
        .padding(.leading, 5)
        .frame(width: 80)
      
      VideoControlSliderView()
        .frame(height: 15)


      Text(humanTime(windowData.videoAsset.durationMillis - windowData.playerTime))
        .padding(.trailing, 5)
        .frame(width: 80)
    }
  }
  
  func humanTime(_ elapsed: Int) -> String {
    let totalSeconds: Double = Double(elapsed) / 1000.0
    
    let hours = Int(totalSeconds / 3600.0)
    let minutes = Int(totalSeconds / 60.0) - (hours * 60)
    let seconds = totalSeconds - Double(hours * 3600) - Double(minutes * 60)
    
    let hh = String(format: "%02d", hours)
    let mm = String(format: "%02d", minutes)
    let ss = String(format: "%02.0f", seconds)
    return "\(hh):\(mm):\(ss)"
  }
}

struct VideoControlTimeView_Previews: PreviewProvider {
  static var previews: some View {
    VideoControlTimeView()
      .environmentObject(WindowData())
  }
}
