//
//  MainShortcutsView.swift
//  Created for Sharktopoda on 9/26/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct MainShortcutsView: View {
  @State private var showingPanel = false
  
  var body: some View {
    HStack {
      Button("Open file...") {
        let dialog = OpenFileView.openFileDialog()
        guard dialog.runModal() == NSApplication.ModalResponse.OK else { return }
        guard let fileUrl = dialog.url else { return }
        VideoWindow.open(url: fileUrl)
      }
      .buttonStyle(.borderless)
      .font(.title2)
      Spacer()
      Text("⌘ O")
        .padding(.trailing, 20)
        .font(.title2)
    }
    
    HStack {
      Button("Open URL...") {
        showingPanel.toggle()
      }
      .buttonStyle(.borderless)
      .font(.title2)
      .floatingPanel(isPresented: $showingPanel, contentRect: OpenUrlView.panelRect) {
        OpenUrlPanel(showPanel: $showingPanel)
      }
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
