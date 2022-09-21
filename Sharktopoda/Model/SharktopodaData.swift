//
//  SharktopodaData.swift
//  Created for Sharktopoda on 9/13/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

final class SharktopodaData: ObservableObject {
  @Published var port: Int = (UserDefaults.standard.object(forKey: PrefKeys.port) as? Int ?? 8800)
  @Published var videoAssets = [String: VideoAsset]()
}
