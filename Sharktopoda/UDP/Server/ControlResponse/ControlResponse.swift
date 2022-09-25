//
//  ControlResponseStatus.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

protocol ControlResponse: Encodable, CustomStringConvertible {
  var response: ControlCommand { get set }
  var status: ControlResponseCommand.Status { get set }
  
  func data() -> Data
}
