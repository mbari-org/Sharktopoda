//
//  VideoWindowMisc.swift
//  Created for Sharktopoda on 11/22/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit

extension VideoWindow {
  override func makeKeyAndOrderFront(_ sender: Any?) {
    super.makeKeyAndOrderFront(sender)
    self.keyInfo = KeyInfo(keyTime: Date(), isKey: true)
  }
}
