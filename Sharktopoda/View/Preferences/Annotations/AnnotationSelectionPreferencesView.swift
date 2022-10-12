//
//  AnnotationSelectionPreferencesView.swift
//  Created for Sharktopoda on 9/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct AnnotationSelectionPreferencesView: View {
  @AppStorage(PrefKeys.selectionBorderColor)
  private var selectionBorderColorHex: String = UserDefaults.standard.hexColor(forKey: PrefKeys.selectionBorderColor)
  
  @AppStorage(PrefKeys.selectionBorderSize)
  private var selectionBorderSize: Int = UserDefaults.standard.integer(forKey: PrefKeys.selectionBorderSize)

  var body: some View {
    Divider()
    
    HStack {
      Text("Annotation Selection")
        .font(.title2)
      Spacer()
    }
    .padding(5)
    
    SizeColorRow(
      label: "Border",
      size: $selectionBorderSize,
      colorHex: $selectionBorderColorHex,
      prefKey: PrefKeys.selectionBorderColor
    )
  }
}

struct AnnotationSelectionPreferencesView_Previews: PreviewProvider {
  static var previews: some View {
    AnnotationSelectionPreferencesView()
  }
}
