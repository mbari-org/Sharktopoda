//
//  UDPClientData.swift
//  Created for Sharktopoda on 12/4/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct UDPClientData {
  let host: String
  let port: Int
  var active: Bool = false
  var error: String? = nil
  
  var endpoint: String {
    "\(host):\(port)"
  }
}

