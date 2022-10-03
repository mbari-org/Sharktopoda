//
//  NSImage.swift
//  Created for Sharktopoda on 10/3/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit

extension NSImage {
  var pngData: Data? {
    guard let tiffRepresentation = tiffRepresentation,
          let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
    return bitmapImage.representation(using: .png, properties: [:])
  }
  
  func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Error? {
    do {
      try pngData?.write(to: url, options: options)
      return nil
    } catch {
      return error
    }
  }
}
