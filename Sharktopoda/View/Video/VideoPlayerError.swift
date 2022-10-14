//
//  VideoPlayerError.swift
//  Created for Sharktopoda on 10/13/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

enum VideoPlayerError: Error {
  case noAsset
  
  var description: String {
    switch self {
      case .noAsset:
        return "Video Player asset not set"
    }
  }
  
  var localizedDescription: String {
    self.description
  }
}
