//
//  AnnotationDisplayPreferencesView.swift
//  Created for Sharktopoda on 9/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI



struct AnnotationDisplayPreferencesView: View {
  @AppStorage(PrefKeys.displayBorderSize)
  private var displayBorderSize: Int = AnnotationPreferencesView.defaultSize
  
  @AppStorage(PrefKeys.displayBorderColor)
  private var displayBorderColorHex: String = AnnotationPreferencesView.defaultColorHex

    var body: some View {
      Divider()
      Text("Annotation Display")
        .font(.title)
      SizeColorRow(
        label: "Border",
        size: $displayBorderSize,
        colorHex: displayBorderColorHex,
        prefKey: PrefKeys.displayBorderColor
      )

    }
}

struct AnnotationDisplyPreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        AnnotationDisplayPreferencesView()
    }
}
