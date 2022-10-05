//
//  OpenFile.swift
//  Created for Sharktopoda on 10/4/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct OpenFileView: View {

  var body: some View {
    Button("Open file...") {
      let dialog = NSOpenPanel()
      
      dialog.showsResizeIndicator    = true
      dialog.showsHiddenFiles        = false
      dialog.allowsMultipleSelection = false
      dialog.canChooseDirectories    = false
      
      guard dialog.runModal() == NSApplication.ModalResponse.OK else { return }

      guard let result = dialog.url else { return }
      
      if let error = VideoWindow.open(path: result.path) as? OpenVideoError {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = error.description
        alert.informativeText = result.path
        alert.runModal()

        return
      }
      return
    }
    .keyboardShortcut("O", modifiers: [.command])
  }
}

struct OpenFile_Previews: PreviewProvider {
  static var previews: some View {
    OpenFileView()
  }
}
