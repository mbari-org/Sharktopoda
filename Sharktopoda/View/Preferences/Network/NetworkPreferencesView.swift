//
//  NetworkPreferencesView.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct NetworkPreferencesView: View {
  var body: some View {
    VStack {
      HStack {
        Text("Configure Network Settings")
          .font(.title)
        Spacer()
      }
      .padding(.leading, 10)
      
      NetworkControlPreferencesView()
      
      Spacer()
    }
    .padding(.top, 20)
  }
}

struct NetworkPreferences_Previews: PreviewProvider {
  static var previews: some View {
    NetworkPreferencesView()
      .frame(width: 568)
  }
}
