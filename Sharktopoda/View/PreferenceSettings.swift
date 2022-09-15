//
//  PreferenceSettings.swift
//  Created for Sharktopoda on 9/14/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct PreferenceSettings: View {
  private static var portKey = "Sharktopoda.port"
  private static var autoStartKey = "Sharktopoda.autoStart"
  
  @AppStorage(PreferenceSettings.portKey, store: .standard) private var port: Int = 8095
  @AppStorage(PreferenceSettings.autoStartKey, store: .standard) private var autoStart: Int = 10
  
  var body: some View {
    Form {
      HStack {
        Text("Sharktopoda Port: ")
        TextField("", value: $port, formatter: NumberFormatter())
          .frame(width: 50)
      }
      HStack {
        Text("Auto-start Delay: ")
        TextField("", value: $autoStart, formatter: NumberFormatter())
          .frame(width: 50)
        Text(" seconds")
      }
    }
    .frame(width: 300)
    .navigationTitle("Sharktopoda Settings")
    .padding(80)
  }
}

struct PreferenceSettings_Previews: PreviewProvider {
  static var previews: some View {
    PreferenceSettings()
  }
}
