//
//  ControlMessage.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

protocol ControlMessage: Decodable {
  var command: ControlCommand { get set }
  
  func process() -> Data
}
