//
//  StatusResponse.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlResponseCommand : ControlResponse {
  var response: ControlCommand
  var status: ControlResponseStatus
  var cause: String? = nil
}
