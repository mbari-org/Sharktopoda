//
//  SharktopodaAppDefaults.swift
//  Created for Sharktopoda on 11/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

extension SharktopodaApp {
  func establishUserDefaults() {
    let appDefault = DefaultPreferences()

    /// UPD Server Port
    if UserDefaults.standard.integer(forKey: PrefKeys.port) == 0 {
      UserDefaults.standard.setValue(appDefault.serverPort, forKey: PrefKeys.port)
    }
    
    /// Annotation Creation
    if UserDefaults.standard.color(forKey: PrefKeys.creationCursorColor) == .black {
      UserDefaults.standard.setHexColor(appDefault.colorHex, forKey: PrefKeys.creationCursorColor)
    }
    if UserDefaults.standard.integer(forKey: PrefKeys.creationCursorSize) == 0 {
      UserDefaults.standard.setValue(appDefault.cursorSize, forKey: PrefKeys.creationCursorSize)
    }
    if UserDefaults.standard.color(forKey: PrefKeys.creationBorderColor) == .black {
      UserDefaults.standard.setHexColor(appDefault.colorHex, forKey: PrefKeys.creationBorderColor)
    }
    if UserDefaults.standard.integer(forKey: PrefKeys.creationBorderSize) == 0 {
      UserDefaults.standard.setValue(appDefault.borderSize, forKey: PrefKeys.creationBorderSize)
    }
    
    /// Annotation Display
    if UserDefaults.standard.color(forKey: PrefKeys.displayBorderColor) == .black {
      UserDefaults.standard.setHexColor(appDefault.colorHex, forKey: PrefKeys.displayBorderColor)
    }
    if UserDefaults.standard.integer(forKey: PrefKeys.displayBorderSize) == 0 {
      UserDefaults.standard.setValue(appDefault.borderSize, forKey: PrefKeys.displayBorderSize)
    }
    if UserDefaults.standard.integer(forKey: PrefKeys.displayTimeWindow) == 0 {
      UserDefaults.standard.setValue(appDefault.displayTimeWindow, forKey: PrefKeys.displayTimeWindow)
    }
    
    /// Annotation Selection
    if UserDefaults.standard.color(forKey: PrefKeys.selectionBorderColor) == .black {
      UserDefaults.standard.setHexColor(appDefault.colorHex, forKey: PrefKeys.selectionBorderColor)
    }
    if UserDefaults.standard.integer(forKey: PrefKeys.selectionBorderSize) == 0 {
      UserDefaults.standard.setValue(appDefault.borderSize, forKey: PrefKeys.selectionBorderSize)
    }
    
    /// Annotation Caption
    if UserDefaults.standard.string(forKey: PrefKeys.captionDefault) == nil {
      UserDefaults.standard.setValue(appDefault.caption, forKey: PrefKeys.captionDefault)
    }
    if UserDefaults.standard.color(forKey: PrefKeys.captionFontColor) == .black {
      UserDefaults.standard.setHexColor(appDefault.fontColorHex, forKey: PrefKeys.captionFontColor)
    }
    if UserDefaults.standard.integer(forKey: PrefKeys.captionFontSize) == 0 {
      UserDefaults.standard.setValue(appDefault.fontSize, forKey: PrefKeys.captionFontSize)
    }
  }
}
