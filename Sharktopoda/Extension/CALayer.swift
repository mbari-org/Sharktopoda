//
//  CALayer.swift
//  Created for Sharktopoda on 11/2/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit

extension CALayer {
  static func noAnimation(_ updates: () -> Void) {
    CATransaction.begin()
    CATransaction.setValue(true, forKey: kCATransactionDisableActions)
    updates()
    CATransaction.commit()
  }
}
