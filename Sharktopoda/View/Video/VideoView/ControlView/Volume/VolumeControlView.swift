//
//  VolumeControlView
//  Created for Sharktopoda on 09/05/23
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct VolumeControlView: View {
  @EnvironmentObject var windowData: WindowData
  
  var body: some View {
    HStack {
      VolumeControlButton()
        .padding(.trailing, 10)
      VolumeControlSlider()
    }
  }
}

