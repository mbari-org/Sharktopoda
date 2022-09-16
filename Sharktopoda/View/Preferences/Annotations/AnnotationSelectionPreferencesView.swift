//
//  AnnotationSelectionPreferencesView.swift
//  Created for Sharktopoda on 9/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct AnnotationSelectionPreferencesView: View {
  @AppStorage(PrefKeys.selectionBorderSize)
  private var selectionBorderSize: Int = AnnotationPreferencesView.defaultSize
  
  @AppStorage(PrefKeys.selectionBorderColor)
  private var selectionBorderColorHex: String = AnnotationPreferencesView.defaultColorHex
  
  var body: some View {
    Divider()
    
    HStack {
      Text("Annotation Selection")
        .font(.title)
      Spacer()
    }
    .padding(5)
    
    SizeColorRow(
      label: "Border",
      size: $selectionBorderSize,
      colorHex: selectionBorderColorHex,
      prefKey: PrefKeys.selectionBorderColor
    )
  }
}

struct AnnotationSelectionPreferencesView_Previews: PreviewProvider {
  static var previews: some View {
    AnnotationSelectionPreferencesView()
  }
}
