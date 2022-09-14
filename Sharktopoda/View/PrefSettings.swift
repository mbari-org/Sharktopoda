//
//  PrefSettings.swift
//  Created for Sharktopoda on 9/14/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct PrefSettings: View {
  @AppStorage("Sharktopoda.port") private var port: Int = 8095
  
  var body: some View {
    Form {
      HStack {
        Text("Port: ")
        TextField("", value: $port, formatter: NumberFormatter())
          .frame(width: 50)
      }
    }
    .frame(width: 300)
    .navigationTitle("Sharktopoda Settings")
    .padding(80)
  }
}

struct PrefSettings_Previews: PreviewProvider {
  static var previews: some View {
    PrefSettings()
  }
}
