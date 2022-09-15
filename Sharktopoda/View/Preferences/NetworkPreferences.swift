//
//  NetworkPreferences.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct NetworkPreferences: View {
  private static var portKey = "Sharktopoda.port"
  private static var timeoutKey = "Sharktopoda.timout"
  
  @AppStorage(NetworkPreferences.portKey, store: .standard) private var port: Int = 8095
  @AppStorage(NetworkPreferences.timeoutKey, store: .standard) private var timeout: Int = 1000


  var body: some View {
    VStack {
      Form {
        HStack {
          Text("Sharktopoda Port: ")
          TextField("", value: $port, formatter: NumberFormatter())
            .frame(width: 50)
        }
        HStack {
          Text("UDP Timeout: ")
          TextField("", value: $timeout, formatter: NumberFormatter())
            .frame(width: 50)
          Text(" milliseconds")
        }
      }
      
      Spacer()
    }
  }
}

struct NetworkPreferences_Previews: PreviewProvider {
  static var previews: some View {
    NetworkPreferences()
  }
}
