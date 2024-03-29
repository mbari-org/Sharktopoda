//
//  SharktopodaCommands.swift
//  Created for Sharktopoda on 9/17/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct SharktopodaCommands: Commands {
  var body: some Commands {
    CommandGroup(replacing: .newItem, addition: {
      OpenMainView()
        .keyboardShortcut("N", modifiers: [.command])
    })
    
    CommandGroup(after: CommandGroupPlacement.newItem) {
      Divider()

      OpenFileView()
        .keyboardShortcut("O", modifiers: [.command])

      OpenUrlView()
        .keyboardShortcut("O", modifiers: [.shift, .command])
    }
  }
}
