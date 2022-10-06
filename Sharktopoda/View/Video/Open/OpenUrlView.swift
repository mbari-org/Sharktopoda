//
//  OpenURLView.swift
//  Created for Sharktopoda on 10/5/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct OpenUrlView: View {
  @State private var showingPanel = false

  private let panelRect = CGRect(x: 0, y: 0, width: 600, height: 180)
  
  var body: some View {
    Button("Open URL...") {
      showingPanel.toggle()
    }
    .floatingPanel(isPresented: $showingPanel, contentRect: panelRect) {
      OpenUrlPanel(showPanel: $showingPanel)
    }
  }
}

struct OpenUrlView_Previews: PreviewProvider {
  static var previews: some View {
    OpenUrlView()
  }
}
