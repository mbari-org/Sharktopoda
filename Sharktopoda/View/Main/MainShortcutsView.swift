//
//  MainShortcutsView.swift
//  Created for Sharktopoda on 9/26/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct MainShortcutsView: View {
  var body: some View {
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
  }
}

struct MainShortcutsView_Previews: PreviewProvider {
  static var previews: some View {
    MainShortcutsView()
  }
}
