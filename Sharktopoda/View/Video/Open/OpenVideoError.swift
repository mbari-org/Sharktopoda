//
//  OpenVideoError.swift
//  Created for Sharktopoda on 10/13/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

enum OpenVideoError: Error, CustomDebugStringConvertible {
  
  case invalidUrl
  case notLoaded
  case notPlayable
  case notReachable
  case unknown(_ cause: String)
  
  var description: String {
    switch self {
      case .invalidUrl:
        return "Invalid URL"
        
      case .notLoaded:
        return "Video not loaded"

      case .notPlayable:
        return "Video not playable"

      case .notReachable:
        return "Video not reachable"

      case .unknown(let cause):
        return cause
    }
  }

  var debugDescription: String {
    description
  }
  
  var localizedDescription: String {
    self.description
  }
}
