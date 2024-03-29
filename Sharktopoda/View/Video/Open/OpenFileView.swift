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
      let dialog = OpenFileView.openFileDialog()
      
      dialog.showsResizeIndicator    = true
      dialog.showsHiddenFiles        = false
      dialog.allowsMultipleSelection = false
      dialog.canChooseDirectories    = false
      dialog.isFloatingPanel         = true
      
      guard dialog.runModal() == NSApplication.ModalResponse.OK else { return }
      guard let fileUrl = dialog.url else { return }
      
      VideoWindow.open(url: fileUrl)
    }
  }
  
  static func openFileDialog() -> NSOpenPanel {
    let dialog = NSOpenPanel()
    
    dialog.showsResizeIndicator    = true
    dialog.showsHiddenFiles        = false
    dialog.allowsMultipleSelection = false
    dialog.canChooseDirectories    = false
    dialog.isFloatingPanel         = true
    
    return dialog
  }
}

struct OpenFile_Previews: PreviewProvider {
  static var previews: some View {
    OpenFileView()
  }
}
