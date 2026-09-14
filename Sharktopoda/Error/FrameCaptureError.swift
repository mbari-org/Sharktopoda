//
//  FrameCaptureError.swift
//  Created for Sharktopoda on 10/4/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import Foundation

enum FrameCaptureError: Error {
  case notWritable
  case exists
  case malformedUrl
  case pngRepresentation
  case notFileUrl
  case unexpectedActualTime(requested: CMTime, actual: CMTime)

  public var description: String {
    switch self {
      case .notWritable:
        return "Image location not writable"
      case .exists:
        return "Image file exists"
      case .malformedUrl:
        return "Image location is malformed URL"
      case .pngRepresentation:
        return "Failed representing image as PNG"
      case .notFileUrl:
        return "Image location not a file URL"
      case .unexpectedActualTime(let requested, let actual):
        return "Frame grab actualTime \(actual.seconds)s != requested \(requested.seconds)s"
    }
  }
}

extension FrameCaptureError: LocalizedError {
  var errorDescription: String? { description }
}
