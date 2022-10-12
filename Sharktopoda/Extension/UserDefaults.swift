//
//  UserDefaults.swift
//  Created for Sharktopoda on 10/3/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

extension UserDefaults {
  func color(forKey key: String) -> Color {
    let hex = hexColor(forKey: key)
    guard let color = Color(hex: hex) else { return .red }
    return color
  }
  
  func hexColor(forKey key: String) -> String {
    guard let hexColor = object(forKey: key) as? String else { return "#000000" }
    return hexColor
  }

  func setColor(_ color: Color, forKey key: String) {
    set(color.toHex(), forKey: key)
  }
  
  func setHexColor(_ hexColor: String, forKey key: String) {
    set(hexColor, forKey: key)
  }
}
