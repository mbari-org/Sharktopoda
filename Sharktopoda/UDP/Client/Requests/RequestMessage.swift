//
//  RequestMessage.swift
//  Created for Sharktopoda on 9/20/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

protocol RequestMessage: Encodable {
  var command: RequestCommand { get set }
  
  func jsonData() -> Data
}
