//
//  Main.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct MainView: View {
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
        
        Spacer()

        MainUDPStatusView()
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
    MainView()
      .environmentObject(SharktopodaData())
  }
}
