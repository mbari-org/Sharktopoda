//
//  AnnotationPreferencesView.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI



struct AnnotationPreferencesView: View {
  @AppStorage(PrefKeys.showAnnotations)
  private var showAnnotations: Bool = UserDefaults.standard.bool(forKey: PrefKeys.showAnnotations)
    
  var body: some View {
    VStack {
      HStack {
        Text("Configure Annotation Display")
          .font(.title)
        Spacer()
      }
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
      
      Spacer()
    }
    .padding(.top, 20)

  }
}

struct AnnotationPreferences_Previews: PreviewProvider {
  static var previews: some View {
    AnnotationPreferencesView()
  }
}
