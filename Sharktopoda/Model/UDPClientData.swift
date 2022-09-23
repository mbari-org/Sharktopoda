//
//  UDPClientData.swift
//  Created for Sharktopoda on 9/23/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

final class UDPClientData: ObservableObject {
  var host: String = ""
  var port: Int = 0
  var active: Bool = false
  var error: String? = nil
  
  var endpoint: String {
    "\(host):\(port)"
  }
  
//  func connect(
}
