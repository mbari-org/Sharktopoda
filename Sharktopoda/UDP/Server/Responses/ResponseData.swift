//
//  ResponseData.swift
//  Created for Sharktopoda on 9/19/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ResponseData {
  
  static func ok(_ response: String) -> Data {
    StatusResponse(response, status: .ok).jsonData()
  }
  
  static func failed(_ response: String, cause: String? = nil) -> Data {
    StatusResponse(response, status: .failed, cause: cause).jsonData()
  }
  
  static func ping() -> Data {
    ResponseData.ok("ping")
  }
  
}
