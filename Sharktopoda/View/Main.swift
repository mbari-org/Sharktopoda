//
//  Main.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct Main: View {
  @EnvironmentObject var sharktopodaData: SharktopodaData
  
  let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
  
  
  private static var ratio: CGFloat = 1.75
  private static var height: CGFloat = 425
  private static var width = CGFloat(Main.height * Main.ratio)
  private static var updConnectionFont = Font.system(size: 12).monospaced()

  var body: some View {
    HStack {
      VStack(spacing: 10) {
        Image("Sharktopoda")
          .resizable()
          .scaledToFit()
        Text("Sharktopoda")
          .font(.largeTitle)
        Text(appVersion)
          .font(.title3)
      }
      .frame(width: 256, height: 256)
      .padding(.bottom, 80)
      
      Divider()
      
      VStack(alignment: .leading, spacing: 20) {
        HStack {
          Text("Open ...")
            .font(.title2)
          Spacer()
          Text("⌘ O")
            .padding(.trailing, 20)
            .font(.title2)
        }
        HStack {
          Text("Open URL ...")
            .font(.title2)
          Spacer()
          Text("⇧ ⌘ O")
            .padding(.trailing, 20)
            .font(.title2)
        }
        
        Spacer()
        
        Text("UDP <-- port \(String(sharktopodaData.udpServer.port))")
          .font(Main.updConnectionFont)
        
        if let clientData = sharktopodaData.udpClient.clientData, clientData.active {
          Text("UDP --> port \(String(clientData.port)) on host \(clientData.host)")
            .font(Main.updConnectionFont)
        } else {
          Text("UDP --> not connected")
            .font(Main.updConnectionFont)
        }
      }
      .padding(20)
      .padding(.top, 20)
      .frame(maxWidth: .infinity)
    }
    .frame(width: Main.width, height: Main.height)
  }
}

struct Main_Previews: PreviewProvider {
  static var previews: some View {
    Main()
      .environmentObject(SharktopodaData())
  }
}
