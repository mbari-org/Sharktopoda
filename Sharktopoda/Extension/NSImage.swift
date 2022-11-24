//
//  NSImage.swift
//  Created for Sharktopoda on 10/3/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit

extension NSImage {
  var pngData: Data? {
    guard let tiff = tiffRepresentation,
          let bitmapImage = NSBitmapImageRep(data: tiff) else { return nil }
    return bitmapImage.representation(using: .png, properties: [:])
  }
  
  func writePng(to destination: String) -> Error? {
    do {
      guard let fileUrl = URL(string: destination) else {
        return FrameCaptureError.notFileUrl
      }

      guard !FileManager.default.fileExists(atPath: fileUrl.path) else {
        return FrameCaptureError.exists
      }

      let dirPath = fileUrl.deletingLastPathComponent().path
      guard FileManager.default.isWritableFile(atPath: dirPath) else {
        return FrameCaptureError.notWritable
      }
      
      
      guard let data = pngData else {
        return FrameCaptureError.pngRepresentation
      }

      UDP.log("Write image data to: \(fileUrl)")

      try data.write(to: fileUrl, options: .withoutOverwriting)

      return nil
    } catch {
      
      return error
    }
  }
}
