//
//  MainTitleView.swift
//  Created for Sharktopoda on 9/26/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct MainTitleView: View {
  let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
  
  var body: some View {
    VStack(spacing: 10) {
      Image("Sharktopoda")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .scaledToFit()
        .padding()
      Text("Sharktopoda")
        .font(.largeTitle)
      Text(appVersion)
        .font(.title3)
      
      Spacer()
    }
  }
}

struct MainTitleView_Previews: PreviewProvider {
  static var previews: some View {
    MainTitleView()
  }
}
