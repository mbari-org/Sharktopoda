//
//  PrefKeys.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct PrefKeys {
  private static var sharktopoda = "Sharktopoda"
  
  private static var network = "\(PrefKeys.sharktopoda).network"
  static var port = "\(PrefKeys.network).port"
  static var timeout = "\(PrefKeys.network).timeout"
    
  private static var annotation = "\(PrefKeys.sharktopoda).annotation"
  private static var caption = "\(PrefKeys.sharktopoda).caption"

  static var showAnnotations = "\(PrefKeys.annotation).show"
  
  // Annotation Creation
  private static var creation = "\(PrefKeys.annotation).creation"

  private static var creationCursor = "\(PrefKeys.creation).cursor"
  static var creationCursorSize = "\(PrefKeys.creationCursor).size"
  static var creationCursorColor = "\(PrefKeys.creationCursor).color"

  private static var creationBorder = "\(PrefKeys.creation).border"
  static var creationBorderSize = "\(PrefKeys.creationBorder).size"
  static var creationBorderColor = "\(PrefKeys.creationBorder).color"

  // Annotation Display
  private static var display = "\(PrefKeys.annotation).display"

  private static var displayBorder = "\(PrefKeys.display).border"
  static var displayBorderSize = "\(PrefKeys.displayBorder).size"
  static var displayBorderColor = "\(PrefKeys.displayBorder).color"

  // Annotation Selection
  private static var selection = "\(PrefKeys.annotation).selection"
  
  private static var selectionBorder = "\(PrefKeys.selection).border"
  static var selectionBorderSize = "\(PrefKeys.selectionBorder).size"
  static var selectionBorderColor = "\(PrefKeys.selectionBorder).color"

  // Caption Display
  private static var captionDisplay = "\(PrefKeys.caption).display"

  private static var captionFont = "\(PrefKeys.captionDisplay).font"
  static var captionFontSize = "\(PrefKeys.captionFont).size"
  static var captionFontColor = "\(PrefKeys.captionFont).color"
}
