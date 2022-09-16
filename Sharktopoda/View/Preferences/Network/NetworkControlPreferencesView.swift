//
//  NetworkControlPreferencesView.swift
//  Created for Sharktopoda on 9/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct NetworkControlPreferencesView: View {
  @AppStorage(PrefKeys.port) private var port: Int = 8095
  @AppStorage(PrefKeys.timeout) private var timeout: Int = 1000
  
  var body: some View {
    Divider()
    
    HStack {
      Text("Remote Control")
        .font(.title2)
      Spacer()
    }
    .padding(5)
    
    Form {
      HStack {
        Text("UDP Port: ")
          .font(.title3)
        
        TextField("", value: $port, formatter: NumberFormatter())
          .frame(width: 60)
          .multilineTextAlignment(.trailing)
        
        Spacer()
      }
      
      HStack {
        Text("UDP Timeout: ")
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
