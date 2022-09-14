//
//  ContentView.swift
//  Created for Sharktopoda on 9/12/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Text("Video")
        .frame(minWidth: 700, minHeight: 300)

      Text("Hideable Control")
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
