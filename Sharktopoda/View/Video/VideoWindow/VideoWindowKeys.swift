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
    
//    print("keyCode: \(event.keyCode)")
    
    func isCommand(_ event: NSEvent) -> Bool {
      event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command
    }
    
    func isControl(_ event: NSEvent) -> Bool {
      event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .control
    }
    
    /// Cmd-Delete:  Delete selected localizations
    if isCommand(event), event.keyCode == KeyCode.delete.rawValue {
      localizations.deleteSelected()
      playerView.clearConcept()
      return
    }
    
    /// Space:  Toggle play/pause forward
    /// Ctrl-Space:  Toggle play/pause and direction
    if event.keyCode == KeyCode.space.rawValue {
      let playDirection: Float = isControl(event) ? -1 : 1
      let playRate = playDirection * videoValues.rate
      playerControl.paused ? playerControl.play(rate: playRate) : pause()
      return
    }
    
    if event.keyCode == KeyCode.leftArrow.rawValue {
      advance(steps: -1)
      return
    }

    if event.keyCode == KeyCode.rightArrow.rawValue {
      advance(steps: 1)
      return
    }

    super.keyDown(with: event)
  }
}

