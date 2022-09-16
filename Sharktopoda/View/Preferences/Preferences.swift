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
          // CxNote ternary selection of buttonStyle did not work
          if (displayAnnotations) {
            Button {
              displayAnnotations = true
            } label: {
              Text("Annotations")
            }
            .buttonStyle(.bordered)
          } else {
            Button {
              displayAnnotations = true
            } label: {
              Text("Annotations")
            }
            .buttonStyle(.borderless)
            .padding(.leading, 8)
          }
          
          if (displayAnnotations) {
            Button {
              displayAnnotations = false
            } label: {
              Text("Network")
            }
            .buttonStyle(.borderless)
            .padding(.leading, 8)
          } else {
            Button {
              displayAnnotations = false
            } label: {
              Text("Network")
            }
            .buttonStyle(.bordered)
          }
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
        NetworkPreferencesView()
      }
      
      Spacer()
    }
    .navigationTitle("Preferences")
    .frame(width: 700, height: 550)
    
  }
}

struct Preferences_Previews: PreviewProvider {
  static var previews: some View {
    Preferences()
  }
}
