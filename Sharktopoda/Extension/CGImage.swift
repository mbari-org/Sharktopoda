//
//  CGImage.swift
//  Created for Sharktopoda on 10/3/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit

extension CGImage {
  func pngWrite(to fileUrl: URL) -> Error? {
    let nsImage = NSImage(cgImage: self, size: .zero)
    return nsImage.writePng(to: fileUrl)
  }
}
