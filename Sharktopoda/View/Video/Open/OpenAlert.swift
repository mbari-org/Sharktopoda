//
//  OpenAlert.swift
//  Created for Sharktopoda on 10/6/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct OpenAlert {
  var alert: NSAlert?

  init(path: String, error: OpenVideoError) {
    let alert = NSAlert()
    alert.alertStyle = .warning
    alert.messageText = error.alertMessage
    alert.informativeText = path
    
    self.alert = alert
  }

  func show() {
    alert?.runModal()
  }

}
