//
//  ControlResponseStatus.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

enum ControlResponseStatus: String, Codable {
  case ok
  case failed
}

protocol ControlResponse: Encodable, CustomStringConvertible {
  var response: ControlCommand { get set }
  var status: ControlResponseStatus { get set }
  
  func data() -> Data
}

extension ControlResponse {
  
  var description: String {
    "\(response.rawValue) \(status.rawValue)"
  }
  
  func data() -> Data {
    try! UDPMessageCoder.encode(self)
  }
}

