//
//  SharktopodaData.swift
//  Created for Sharktopoda on 9/13/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Combine
import Foundation
import Network
import SwiftUI

final class SharktopodaData: ObservableObject {
  @Published var videoAssets = [String: VideoAsset]()
  
  @Published var wtf: String = "WTF?"
  
}
