//
//  MainUDPStatusView.swift
//  Created for Sharktopoda on 9/26/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct MainUDPStatusView: View {
  @EnvironmentObject var sharktopodaData: SharktopodaData
  
  private let updStatusFont = Font.title3

  var body: some View {
    if let error = sharktopodaData.udpServer.error {
      HStack {
        Text("UDP  ←")
          .font(updStatusFont)
        Text("\(error)")
          .font(updStatusFont)
          .foregroundColor(.red)
      }
    } else {
      Text("UDP  ←  port \(String(sharktopodaData.udpServer.port))")
        .font(updStatusFont)
    }
    
    let clientData = sharktopodaData.udpClient.clientData
    if clientData.active {
      Text("UDP  →  port \(String(clientData.port)) on \(clientData.host)")
        .font(updStatusFont)
    } else {
      HStack {
        Text("UDP  →")
          .font(updStatusFont)
        Text("Not connected")
          .font(updStatusFont)
          .foregroundColor(.red)
      }
    }
    
  }
}

struct MainUDPStatusView_Previews: PreviewProvider {
  static var previews: some View {
    MainUDPStatusView()
  }
}
