//
//  VolumeControlSlider
//  Created for Sharktopoda on 09/05/23
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct VolumeControlSlider: View {
  @EnvironmentObject var windowData: WindowData

  var body: some View {
    Slider(value: $windowData.playerVolumeLevel)
      .tint(Color(red: 85, green: 85, blue: 85))
      .disabled(windowData.playerVolumeMute)
  }
}
