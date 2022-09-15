//
//  Main.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct Main: View {
  var body: some View {

    HStack {
      Image("AppIcon")
      
      VStack {
        Text("Video")
        
        Text("Hideable Control")
      }
      .padding()
    }
    .frame(minWidth: 700, minHeight: 300)
  }
}

struct Main_Previews: PreviewProvider {
  static var previews: some View {
    Main()
  }
}
