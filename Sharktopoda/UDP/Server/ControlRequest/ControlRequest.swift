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
    ControlResponseCommand(response: command, status: .ok)
  }

  func failed(_ cause: String? = nil) -> ControlResponse {
    ControlResponseCommand(response: command, status: .failed, cause: cause)
  }
}
