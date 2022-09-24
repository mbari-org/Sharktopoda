//
//  ClientMessage.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

protocol ClientMessage: Encodable {
  var command: ClientCommand { get set }
  
  func data() -> Data
}
