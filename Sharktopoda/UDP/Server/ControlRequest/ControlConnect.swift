//
//  ControlConnect.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation
import Network

struct ControlConnect: ControlRequest {
  var command: ControlCommand
  @Default<String.Localhost> var host: String
  let port: Int
  
  var endpoint: String {
    "\(host):\(port)"
  }
  
  func process() -> ControlResponse {
    if endpoint != UDP.client.clientData.endpoint {
      UDPClient.connect(using: self) { udpClient in
        // If new client is active, use it
        if udpClient.clientData.active {
          UDP.client.stop()
          DispatchQueue.main.async {
            UDP.sharktopodaData.udpClient = udpClient
          }
        } else {
          // If current client active, keep it
          if UDP.client.clientData.active {
            return
          } else {
            // Replace current inactive client active with new inactive host/port client
            DispatchQueue.main.async {
              UDP.sharktopodaData.udpClient = udpClient
            }
          }
        }
      }
    }
    return ControlResponseOk(response: command)
  }
}
