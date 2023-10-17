//
//  OpenVideoError.swift
//  Created for Sharktopoda on 10/13/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

enum OpenVideoError: Error, CustomDebugStringConvertible {
  
  case invalidPath(_ path: String)
  case loadProperty(_ url: URL, error: Error)
  case noVideo(_ url: URL)
  case notPlayable(_ url: URL)
  case notReachable(_ url: URL)
  case unknown(_ cause: String)
  
  var description: String {
    switch self {
      case .invalidPath(let path):
        return "Invalid URL: \(path)"
        
      case .loadProperty(let url, let error):
        return "Video \(url.absoluteString): \(error.localizedDescription)"

      case .noVideo(let url):
        return "File has no video track: \(url.absoluteString)"
        
      case .notPlayable(let url):
        return "Video not playable: \(url.absoluteString)"

      case .notReachable(let url):
        return "Video not reachable: \(url.absoluteString)"

      case .unknown(let cause):
        return cause
    }
  }
  
  var alertMessage: String {
    switch self {
      case .invalidPath(let path):
        return "Invalid URL: \n\n\(path)"
        
      case .loadProperty(let url, let error):
        return "Video \(url.absoluteString): \n\n\(error.localizedDescription)"
        
      case .noVideo(let url):
        return "Video has no tracks: \n\n\(url.absoluteString)"
        
      case .notPlayable(let url):
        return "Video not playable: \n\n\(url.absoluteString)"
        
      case .notReachable(let url):
        return "Video not reachable: \n\n\(url.absoluteString)"
        
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
