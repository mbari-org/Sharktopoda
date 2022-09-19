//
//  ResponseData.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ResponseData {

  static func ping() -> Data {
    StatusResponse(response: "ping", status: .ok).jsonData()
  }
  
  static func failed(response: String, cause: String? = nil) -> Data {
    StatusResponse(response: response, status: .failed, cause: cause).jsonData()
  }
}
