//
//  AnnotationCaptionPreferencesView.swift
//  Created for Sharktopoda on 9/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct AnnotationCaptionPreferencesView: View {
  @AppStorage(PrefKeys.captionFontSize)
  private var captionFontSize: Int = AnnotationPreferencesView.defaultSize
  
  @AppStorage(PrefKeys.captionFontColor)
  private var captionFontColorHex: String = AnnotationPreferencesView.defaultColorHex
  
  var body: some View {
    Divider()
    
    HStack {
      Text("Caption Display")
        .font(.title)
      Spacer()
    }
    .padding(5)
    
    SizeColorRow(
      label: "Font",
      size: $captionFontSize,
      colorHex: captionFontColorHex,
      prefKey: PrefKeys.captionFontColor
    )
  }
}

struct AnnotationCaptionPreferencesView_Previews: PreviewProvider {
  static var previews: some View {
    AnnotationCaptionPreferencesView()
  }
}
