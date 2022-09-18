//
//  SharktopodaData.swift
//  Created for Sharktopoda on 9/13/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Combine
import SwiftUI

final class SharktopodaData: ObservableObject {
  @AppStorage(PrefKeys.port) private var port: Int = 8800

  init() {
    print("SharktopodaData port=\(port)")
  }
    
  @Published var videoAssets = [String: VideoAsset]()
}
