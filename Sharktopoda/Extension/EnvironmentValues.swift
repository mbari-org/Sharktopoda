//
//  EnvironmentValues.swift
//  Created for Sharktopoda on 10/6/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

private struct FloatingPanelKey: EnvironmentKey {
  static let defaultValue: NSPanel? = nil
}

extension EnvironmentValues {
  var floatingPanel: NSPanel? {
    get { self[FloatingPanelKey.self] }
    set { self[FloatingPanelKey.self] = newValue }
  }
}
