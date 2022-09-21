//
//  ControlResponseMessage.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

protocol ControlResponseMessage: Encodable {
  var response: ControlCommand { get set }
  var status: ResponseStatus { get set }
  
  func data() -> Data
}
