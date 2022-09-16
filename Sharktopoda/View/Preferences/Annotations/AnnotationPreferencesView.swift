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
  
  @AppStorage(PrefKeys.showAnnotations)
  private var showAnnotations: Bool = true
  
  var body: some View {
    
    VStack {
      HStack {
        Text("Configure Video Annotation Display")
          .font(.title)
        Spacer()
      }
      .padding(.top, 20)
      .padding(.leading, 10)
      
      HStack {
        Toggle("  Show Annotations", isOn: $showAnnotations)
          .toggleStyle(.checkbox)
        Spacer()
      }
      .padding(.leading, 30)
      .padding(.bottom, 10)
      
      AnnotationCreationPreferencesView()
      
      AnnotationDisplayPreferencesView()
      
      AnnotationSelectionPreferencesView()
      
      AnnotationCaptionPreferencesView()
      
      Divider()
      
      Spacer()
      
    }
  }
}

struct AnnotationPreferences_Previews: PreviewProvider {
  static var previews: some View {
    AnnotationPreferencesView()
  }
}
