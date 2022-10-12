//
//  AnnotationCreation.swift
//  Created for Sharktopoda on 9/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct AnnotationCreationPreferencesView: View {
  @AppStorage(PrefKeys.creationCursorColor)
  private var creationCursorColorHex: String = UserDefaults.standard.hexColor(forKey: PrefKeys.creationCursorColor)
  
  @AppStorage(PrefKeys.creationCursorSize)
  private var creationCursorSize: Int = UserDefaults.standard.integer(forKey: PrefKeys.creationCursorSize)
  
  @AppStorage(PrefKeys.creationBorderColor)
  private var creationBorderColorHex: String = UserDefaults.standard.hexColor(forKey: PrefKeys.creationBorderColor)
  
  @AppStorage(PrefKeys.creationBorderSize)
  private var creationBorderSize: Int = UserDefaults.standard.integer(forKey: PrefKeys.creationBorderSize)
  
  var body: some View {
    Divider()

    HStack {
      Text("Annotation Creation")
        .font(.title2)
      Spacer()
    }
    .padding(5)
    
    SizeColorRow(
      label: "Cursor",
      size: $creationCursorSize,
      colorHex: $creationCursorColorHex,
      prefKey: PrefKeys.creationCursorColor
    )

    SizeColorRow(
      label: "Border",
      size: $creationBorderSize,
      colorHex: $creationBorderColorHex,
      prefKey: PrefKeys.creationBorderColor
    )

  }
}

struct AnnotationCreation_Previews: PreviewProvider {
  static var previews: some View {
    AnnotationCreationPreferencesView()
  }
}
