//
//  OpenURLView.swift
//  Created for Sharktopoda on 10/5/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct OpenUrlView: View {
  static let panelRect = CGRect(x: 0, y: 0, width: 600, height: 180)

  @State private var showingPanel = false

  var body: some View {
    Button("Open URL...") {
      showingPanel.toggle()
    }
    .floatingPanel(isPresented: $showingPanel, contentRect: OpenUrlView.panelRect) {
      OpenUrlPanel(showPanel: $showingPanel)
    }
  }
}

struct OpenUrlView_Previews: PreviewProvider {
  static var previews: some View {
    OpenUrlView()
  }
}
