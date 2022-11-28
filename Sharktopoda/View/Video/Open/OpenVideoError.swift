//
//  OpenVideoError.swift
//  Created for Sharktopoda on 10/13/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

enum OpenVideoError: Error, CustomDebugStringConvertible {
  
  case invalidPath(_ path: String)
  case notLoaded(_ url: URL)
  case notPlayable(_ url: URL)
  case notReachable(_ url: URL)
  case unknown(_ cause: String)
  
  var description: String {
    switch self {
      case .invalidPath(let path):
        return "Invalid URL: \(path)"
        
      case .notLoaded(let url):
        return "Video not loaded: \(url.absoluteString)"

      case .notPlayable(let url):
        return "Video not playable: \(url.absoluteString)"

      case .notReachable(let url):
        return "Video not reachable: \(url.absoluteString)"

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
