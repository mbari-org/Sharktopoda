//
//  Preferences.swift
//  Created for Sharktopoda on 9/14/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct Preferences: View {
  @State private var displayAnnotations = true
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        VStack(alignment: .leading, spacing: 20) {

          Text("Annotations")
          Text("Network")
        }
        .padding(.top, 20)
        .padding(.leading, 10)
        
        Spacer()
        
        Image("Sharktopoda")
          .resizable()
          .frame(width: 128, height: 128)
      }
      .padding(10)
      
      Divider()
      
      if displayAnnotations {
        AnnotationPreferences()
          .frame(width: 568)
      } else {
        NetworkPreferences()
          .frame(width: 568)
      }
      
    }
    .navigationTitle("Preferences")
    
  }
}

struct Preferences_Previews: PreviewProvider {
  static var previews: some View {
    Preferences()
  }
}
