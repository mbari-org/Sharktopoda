//
//  OpenMainVIew.swift
//  Created for Sharktopoda on 12/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct OpenMainView: View {
  @Environment(\.openWindow) private var openWindow
  
  var body: some View {
    Button("Open Main View") {
      openWindow(id: "main")
    }
  }
}

struct OpenMainVIew_Previews: PreviewProvider {
  static var previews: some View {
    OpenMainView()
  }
}
