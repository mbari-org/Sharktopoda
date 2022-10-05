//
//  SharktopodaCommands.swift
//  Created for Sharktopoda on 9/17/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct SharktopodaCommands: Commands {
  var body: some Commands {
    CommandGroup(after: CommandGroupPlacement.newItem) {
      Divider()
      OpenFileView()
      Button("Open URL...") {
        print("Open URL...")
      }
      .keyboardShortcut("O", modifiers: [.shift, .command])
    }
  }
}
