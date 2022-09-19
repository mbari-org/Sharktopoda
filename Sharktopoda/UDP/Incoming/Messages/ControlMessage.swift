//
//  ControlMessage.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlMessage: Decodable {
  var command: String
  var error: String?
  
  init(_ data: Data) {
    do {
      let controlMessage = try JSONDecoder().decode(ControlMessage.self, from: data)
      command = controlMessage.command
      print("controlMessage command: \(controlMessage.command)")
      
    } catch {
      command = ""
      self.error = "Failed parson JSON"
    }
  }
}
