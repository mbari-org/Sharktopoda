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
            .font(.title2)
          Text("Network")
                      .font(.title2)
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
        AnnotationPreferencesView()
      } else {
        Network()
      }
      
    }
    .navigationTitle("Preferences")
          .frame(width: 700, height: 700)
    
  }
}

struct Preferences_Previews: PreviewProvider {
  static var previews: some View {
    Preferences()
  }
}
