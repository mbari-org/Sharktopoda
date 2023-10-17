//
//  VolumeControlButton
//  Created for Sharktopoda on 09/05/23
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct VolumeControlButton: View {
  @EnvironmentObject var windowData: WindowData
  
  var body: some View {
    ZStack {
      Button(
        action: {
          windowData.playerVolumeMute.toggle()
        },
        label: {
          windowData.playerVolumeMute ? Volume.muteImage : image(value: windowData.playerVolumeLevel)
        }
      )
      .frame(width: 14)
    }
  }
  
  func image(value: Float) -> Image {
    switch value {
      case 0.0:
        return Volume.muteImage
      case 0.00001 ... 0.33:
        return Volume.lowImage
      case 0.33 ... 0.66:
        return Volume.mediumImage
      default:
        return Volume.highImage
    }
  }
  
  private enum Volume {
    case mute
    case low
    case medium
    case high

    static let muteImage = Image(systemName: "speaker.slash.fill")
    static let lowImage = Image(systemName: "speaker.wave.1.fill")
    static let mediumImage = Image(systemName: "speaker.wave.2.fill")
    static let highImage = Image(systemName: "speaker.wave.3.fill")

  }
}

