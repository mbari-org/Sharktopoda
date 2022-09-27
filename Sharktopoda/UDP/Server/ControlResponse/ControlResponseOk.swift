//
//  ControlResponseOk.swift
//  Created for Sharktopoda on 9/27/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlResponseOk : ControlResponse {
  var response: ControlCommand
  var status: ControlResponseStatus = .ok
}
