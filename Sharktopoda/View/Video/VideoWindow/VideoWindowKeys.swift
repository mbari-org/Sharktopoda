//
//  VideoWindowKeys.swift
//  Created for Sharktopoda on 11/22/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit

extension VideoWindow {
  override func keyDown(with event: NSEvent) {
    enum KeyCode: UInt16 {
      case delete = 51
      case leftArrow = 123
      case rightArrow = 124
      case space = 49
    }
    
    func isCommand(_ event: NSEvent) -> Bool {
      event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command
    }
    
    func isControl(_ event: NSEvent) -> Bool {
      event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .control
    }
    
    /// Cmd-Delete:  Delete selected localizations
    if isCommand(event), event.keyCode == KeyCode.delete.rawValue {
      windowData.localizations.deleteSelected()
      // CxInc Concept layers?
      return
    }
    
    /// Space:  Toggle play/pause forward
    /// Ctrl-Space:  Toggle play/pause backward
    if event.keyCode == KeyCode.space.rawValue {
      if windowData.playerDirection != .paused {
        windowData.pause()
        return
      }
      if isControl(event) {
        windowData.playBackward()
        return
      }
      windowData.playForward()
      return
    }
    
    if event.keyCode == KeyCode.leftArrow.rawValue {
      windowData.advance(steps: -1)
      return
    }

    if event.keyCode == KeyCode.rightArrow.rawValue {
      windowData.advance(steps: 1)
      return
    }

    super.keyDown(with: event)
  }
}

