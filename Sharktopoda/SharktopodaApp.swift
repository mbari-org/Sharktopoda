//
//  SharktopodaApp.swift
//  Created for Sharktopoda on 9/12/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

@main
struct SharktopodaApp: App {
  private var port: Int = UserDefaults.standard.integer(forKey: PrefKeys.port)
  
  private let udpQueue: DispatchQueue
  private var udpServer: UDPServer
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    
    Settings {
      Preferences()
    }
  }
  
  init() {
    udpQueue = DispatchQueue(label: "Sharktopoda UDP Queue")

    udpServer = UDPServer(port: UInt16(port), queue: udpQueue)
  }
}
