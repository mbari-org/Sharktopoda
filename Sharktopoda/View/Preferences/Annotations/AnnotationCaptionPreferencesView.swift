//
//  AnnotationCaptionPreferencesView.swift
//  Created for Sharktopoda on 9/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct AnnotationCaptionPreferencesView: View {
  @AppStorage(PrefKeys.captionDefault)
  private var captionDefault: String = UserDefaults.standard.string(forKey: PrefKeys.captionDefault)!

  @AppStorage(PrefKeys.captionFontColor)
  private var captionFontColorHex: String = UserDefaults.standard.hexColor(forKey: PrefKeys.captionFontColor)

  @AppStorage(PrefKeys.captionFontSize)
  private var captionFontSize: Int = UserDefaults.standard.integer(forKey: PrefKeys.captionFontSize)
  
  var body: some View {
    Divider()
    
    HStack {
      Text("Caption Display")
        .font(.title2)
      Spacer()
    }
    .padding(5)
    
    SizeColorRow(
      label: "Font",
      size: $captionFontSize,
      colorHex: $captionFontColorHex,
      prefKey: PrefKeys.captionFontColor
    )
    
    HStack {
      Text("Default Caption")
        .font(.title3)
        .frame(width: 120)
        .padding(.leading, 23)
      TextField("", text: $captionDefault)
        .padding(.leading, 45)
      Spacer()
    }
    .padding(.trailing, 20)
    
  }
}

struct AnnotationCaptionPreferencesView_Previews: PreviewProvider {
  static var previews: some View {
    AnnotationCaptionPreferencesView()
  }
}
