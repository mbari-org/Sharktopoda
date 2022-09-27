//
//  ControlMessage.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

protocol ControlRequest: Decodable, CustomStringConvertible {
  var command: ControlCommand { get set }
  
  func process() -> ControlResponse
}

extension ControlRequest {
  var description: String {
    command.rawValue
  }
  
  func ok() -> ControlResponse {
    ControlResponseOk(response: command)
  }

  func failed(_ cause: String) -> ControlResponse {
    ControlResponseFailed(response: command, cause: cause)
  }
}
