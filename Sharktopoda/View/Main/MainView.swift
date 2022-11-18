//
//  Main.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct MainView: View {
  @EnvironmentObject var sharktopodaData: SharktopodaData
  @Environment(\.openWindow) var openWindow

  private static var ratio: CGFloat = 1.75
  private static var height: CGFloat = 425
  private static var width = CGFloat(MainView.height * MainView.ratio)
  
  var body: some View {
    HStack {
      MainTitleView()
        .frame(width: 256)
        .padding(.top, 20)
      
      Divider()
      
      VStack(alignment: .leading, spacing: 20) {
        MainShortcutsView()
        
        Button("CxDebug") {
          Task {
            if sharktopodaData.videoAssets.isEmpty {
              let id = "b52cf7f1-e19c-40ba-b176-a7e479a3b170"
              let url = URL(string: "https://freetestdata.com/wp-content/uploads/2021/10/Free_Test_Data_1MB_MOV.mov")!
              if let videoAsset = await VideoAsset(id: id, url: url) {
                DispatchQueue.main.async {
                  UDP.sharktopodaData.videoAssets[id] = videoAsset
                  openWindow(value: videoAsset.id)
                }
              }
            } else {
              let videoAsset: VideoAsset = sharktopodaData.videoAssets.values.first!
              DispatchQueue.main.async {
                openWindow(value: videoAsset.id)
              }
            }
          }
        }
        
        Spacer()

        MainUDPStatusView().environmentObject(sharktopodaData)
      }
      .padding(20)
      .padding(.top, 20)
      .frame(maxWidth: .infinity)
    }
    .frame(width: MainView.width, height: MainView.height)
  }
}

struct Main_Previews: PreviewProvider {
  static var previews: some View {
    MainView().environmentObject(SharktopodaData())
  }
}
