//
//  AnnotationPreferences.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct AnnotationPreferences: View {
  private static var defaultSize = 6
  private static var defaultColorHex = "#00ffff"
  
  // Creation
  @AppStorage(PrefKeys.creationCursorSize)
  private var creationCursorSize: Int = AnnotationPreferences.defaultSize
  
  @AppStorage(PrefKeys.creationCursorColor)
  private var creationCursorColorHex: String = AnnotationPreferences.defaultColorHex
  
  @AppStorage(PrefKeys.creationBorderSize)
  private var creationBorderSize: Int = AnnotationPreferences.defaultSize
  
  @AppStorage(PrefKeys.creationBorderColor)
  private var creationBorderColorHex: String = AnnotationPreferences.defaultColorHex
  
  // Display
  @AppStorage(PrefKeys.displayCursorSize)
  private var displayCursorSize: Int = AnnotationPreferences.defaultSize
  
  @AppStorage(PrefKeys.displayCursorColor)
  private var displayCursorColorHex: String = AnnotationPreferences.defaultColorHex
  
  @AppStorage(PrefKeys.displayBorderSize)
  private var displayBorderSize: Int = AnnotationPreferences.defaultSize
  
  @AppStorage(PrefKeys.displayBorderColor)
  private var displayBorderColorHex: String = AnnotationPreferences.defaultColorHex
  
  var body: some View {
    VStack {
      Divider()
      Text("Annotation Creation")
        .font(.title)
      SizeColorRow(
        name: "Cursor",
        size: $creationCursorSize,
        colorHex: creationCursorColorHex,
        prefKey: PrefKeys.creationCursorColor
      )
      SizeColorRow(
        name: "Border",
        size: $creationBorderSize,
        colorHex: creationBorderColorHex,
        prefKey: PrefKeys.creationBorderColor
      )
      Divider()
      Text("Annotation Display")
        .font(.title)
      SizeColorRow(
        name: "Cursor",
        size: $displayCursorSize,
        colorHex: displayCursorColorHex,
        prefKey: PrefKeys.displayCursorColor
      )
      SizeColorRow(
        name: "Border",
        size: $displayBorderSize,
        colorHex: displayBorderColorHex,
        prefKey: PrefKeys.displayBorderColor
      )
      Divider()
    }
  }
}

struct AnnotationPreferences_Previews: PreviewProvider {
  static var previews: some View {
    AnnotationPreferences()
  }
}
