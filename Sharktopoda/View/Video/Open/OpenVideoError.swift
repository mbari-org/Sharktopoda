//
//  OpenVideoError.swift
//  Created for Sharktopoda on 10/13/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

enum OpenVideoError: Error {
  case invalidUrl
  case notPlayable
  case notReachable
  case unknown(_ cause: String)
  
  var description: String {
    switch self {
      case .invalidUrl:
        return "Invalid URL"
        
      case .notPlayable:
        return "Resource not playable"
        
      case .notReachable:
        return "Video file not reachable"
        
      case .unknown(let cause):
        return cause
    }
  }
  
  var localizedDescription: String {
    self.description
  }
}
