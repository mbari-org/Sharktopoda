//
//  AnnotationPreferencesView.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct AnnotationPreferencesView: View {
  static var defaultSize = 6
  static var defaultColorHex = "#00ffff"

  var body: some View {
    VStack {
      AnnotationCreationPreferencesView()

      AnnotationDisplayPreferencesView()

      AnnotationSelectionPreferencesView()
      
      AnnotationCaptionPreferencesView()
      
      Divider()
      
    }
  }
}

struct AnnotationPreferences_Previews: PreviewProvider {
  static var previews: some View {
    AnnotationPreferencesView()
  }
}
