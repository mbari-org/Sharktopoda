//
//  CGPoint.swift
//  Created for Sharktopoda on 10/28/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import CoreGraphics

typealias DeltaPoint = CGPoint

extension CGPoint {
  enum Quadrant: RawRepresentable {
    case qI, qII, qIII, qIV
    
    init?(rawValue: (Int, Int)) {
      switch rawValue {
        case ( 1,  1):  self = .qI
        case (-1,  1):  self = .qII
        case (-1, -1):  self = .qIII
        case ( 1, -1):  self = .qIV
        default:
          return nil
      }
    }
    
    var rawValue: (Int, Int) {
      switch self {
        case .qI:   return ( 1,  1)
        case .qII:  return (-1,  1)
        case .qIII: return (-1, -1)
        case .qIV:  return ( 1, -1)
      }
    }
  }
  
  func abs() -> DeltaPoint {
    DeltaPoint(x: Swift.abs(x), y: Swift.abs(y))
  }
  
  func delta(from point: CGPoint) -> DeltaPoint {
    DeltaPoint(x: x - point.x, y: y - point.y)
  }
  
  func delta(to point: CGPoint) -> DeltaPoint {
    DeltaPoint(x: point.x - x, y: point.y - y)
  }

  func quadrant(of point: CGPoint) -> Quadrant {
    let delta = delta(from: point)
    
    let signX = delta.x < 0 ? 1 : -1
    let signY = delta.y < 0 ? 1 : -1

    return Quadrant(rawValue: (signX, signY))!
  }
  
  func move(by delta: DeltaPoint) -> CGPoint {
    CGPoint(x: x + delta.x, y: y + delta.y)
  }
  
}
