//
//  ControlRemoveLocalizations.swift
//  Created for Sharktopoda on 10/8/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import Foundation

struct ControlRemoveLocalizations: ControlRequest {
  var command: ControlCommand
  var uuid: String
  var localizations: [String]
  
  func process() -> ControlResponse {
    withLocalizations(id: uuid) { videoLocalizations in
      let layers = localizations
        .reduce(into: [CALayer]()) { acc, id in
          if let remove = videoLocalizations.remove(id: id) {
            acc.append(remove.layer)
          }
        }
      
      DispatchQueue.main.async {
        layers
          .forEach { $0.removeFromSuperlayer() }
      }

      return ok()
    }
  }
}
