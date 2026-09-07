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
      OpenFileView.openFile()
    }
  }
  
  static func openFile() {
    let dialog = openFileDialog()
    guard dialog.runModal() == .OK, let fileUrl = dialog.url else { return }
    dialog.orderOut(nil)
    VideoWindow.open(url: fileUrl)
  }
  
  static func openFileDialog() -> NSOpenPanel {
    let dialog = NSOpenPanel()
    
    dialog.showsResizeIndicator    = true
    dialog.showsHiddenFiles        = false
    dialog.allowsMultipleSelection = false
    dialog.canChooseDirectories    = false
    
    return dialog
  }
}

struct OpenFile_Previews: PreviewProvider {
  static var previews: some View {
    OpenFileView()
  }
}
