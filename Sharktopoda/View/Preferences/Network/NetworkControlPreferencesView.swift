//
//  NetworkControlPreferencesView.swift
//  Created for Sharktopoda on 9/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct NetworkControlPreferencesView: View {
  @EnvironmentObject var sharktopodaData: SharktopodaData
  
  // CxNote UPDServer binding ensure pref port is set
  @AppStorage(PrefKeys.port) private var prefPort: Int!
  @AppStorage(PrefKeys.timeout) private var timeout: Int = 1000
  
  var body: some View {
    Divider()
    
    HStack {
      Text("Remote UDP Control")
        .font(.title2)
      Spacer()
    }
    .padding(5)
    
    Form {
      HStack {
        Text("Port: ")
          .font(.title3)
        
        TextField("", value: $prefPort, formatter: NumberFormatter())
          .frame(width: 60)
          .multilineTextAlignment(.trailing)
        
        if sharktopodaData.port != prefPort {
          Button {
            UDP.server.start()
            sharktopodaData.port = prefPort
          } label: {
            Text("Restart UDP Server")
          }
          .buttonStyle(.borderedProminent)
        }
        
        Spacer()
      }
      
      HStack {
        Text("Timeout: ")
          .font(.title3)
        
        TextField("", value: $timeout, formatter: NumberFormatter())
          .frame(width: 60)
          .multilineTextAlignment(.trailing)
        Text(" milliseconds")
        
        Spacer()
      }
    }
    .padding(.leading, 40)
    
  }
}

struct NetworkControlPreferencesView_Previews: PreviewProvider {
  static var previews: some View {
    NetworkControlPreferencesView()
  }
}
