//
//  ColorPref.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

extension Color {
  init?(hex: String) {
    let trimmedHex = hex
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .replacingOccurrences(of: "#", with: "")
    guard trimmedHex.count == 6 else { return nil }

    var rgb: UInt64 = 0
    guard Scanner(string: trimmedHex).scanHexInt64(&rgb) else { return nil }
    
    let r = CGFloat(rgb >> 16) / 255
    let g = CGFloat((rgb >> 8) & 0xff) / 255
    let b = CGFloat(rgb & 0xff) / 255
    
    self.init(red: r, green: g, blue: b, opacity: 1)
  }
  
 func toHex() -> String {
   let colorComponents = self.cgColor?.components
   
   enum ColorComponent: Int {
     case red = 0
     case green
     case blue
   }
   func hexOf(_ component: ColorComponent) -> String {
     String(format: "%02x", Int(round(colorComponents![component.rawValue] * 255)))
   }

   return "#" + hexOf(.red) + hexOf(.green) + hexOf(.blue)
  }
}

