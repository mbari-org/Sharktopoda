//
//  AnnotationCreation.swift
//  Created for Sharktopoda on 9/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct AnnotationCreationPreferencesView: View {
  @AppStorage(PrefKeys.creationCursorSize)
  private var creationCursorSize: Int = AnnotationPreferencesView.defaultSize
  
  @AppStorage(PrefKeys.creationCursorColor)
  private var creationCursorColorHex: String = AnnotationPreferencesView.defaultColorHex
  
  @AppStorage(PrefKeys.creationBorderSize)
  private var creationBorderSize: Int = AnnotationPreferencesView.defaultSize
  
  @AppStorage(PrefKeys.creationBorderColor)
  private var creationBorderColorHex: String = AnnotationPreferencesView.defaultColorHex
  
  var body: some View {
    Divider()
    Text("Annotation Creation")
      .font(.title)
    SizeColorRow(
      label: "Cursor",
      size: $creationCursorSize,
      colorHex: creationCursorColorHex,
      prefKey: PrefKeys.creationCursorColor
    )
    SizeColorRow(
      label: "Border",
      size: $creationBorderSize,
      colorHex: creationBorderColorHex,
      prefKey: PrefKeys.creationBorderColor
    )

  }
}

struct AnnotationCreation_Previews: PreviewProvider {
  static var previews: some View {
    AnnotationCreationPreferencesView()
  }
}
