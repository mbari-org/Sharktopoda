//
//  NetworkControlPreferencesView.swift
//  Created for Sharktopoda on 9/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct NetworkControlPreferencesView: View {
  @EnvironmentObject var sharktopodaData: SharktopodaData
  
  @AppStorage(PrefKeys.timeout) private var timeout: Int = 1000
  
  @State private var prefPort: Int = UserDefaults.standard.integer(forKey: PrefKeys.port)
  @State private var prefPortValid: Bool = true
  
  var body: some View {
    Divider()
    
    HStack {
      Text("UDP Messaging")
        .font(.title2)
      Spacer()
    }
    .padding(5)
    
    Form {
      HStack {
        Text("Server Port: ")
          .font(.title3)
        
        TextField("", value: $prefPort, formatter: NumberFormatter())
          .frame(width: 60)
          .multilineTextAlignment(.trailing)
          .foregroundColor(prefPortValid ? Color.primary : Color.red)
          .onSubmit {
            restartServer()
          }
          .onChange(of: prefPort) { port in
            prefPortValid = prefPort <= UInt16.max
          }
        
        if prefPortValid && sharktopodaData.udpServer.port != prefPort {
          Button {
            restartServer()
          } label: {
            Text("Restart UDP Server")
          }
          .buttonStyle(.borderedProminent)
        }
        
        if let error = sharktopodaData.udpServerError, sharktopodaData.udpServer.port == prefPort {
          Text("\(error)")
            .foregroundColor(.red)
        }
        
        Spacer()
      }
      
      HStack {
        Text("Client Timeout: ")
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
  
  func restartServer() {
    prefPortValid = prefPort <= UInt16.max
    guard prefPortValid else { return }
    
    sharktopodaData.udpServer.stop()
    sharktopodaData.udpServer = UDPServer(port: prefPort)
  }
}

struct NetworkControlPreferencesView_Previews: PreviewProvider {
  static var previews: some View {
    NetworkControlPreferencesView()
  }
}
