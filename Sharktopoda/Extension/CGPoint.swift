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
    case I, II, III, IV
    
    init?(rawValue: (Int, Int)) {
      switch rawValue {
        case ( 1,  1):  self = .I
        case (-1,  1):  self = .II
        case (-1, -1):  self = .III
        case ( 1, -1):  self = .IV
        default:
          return nil
      }
    }
    
    var rawValue: (Int, Int) {
      switch self {
        case .I:   return ( 1,  1)
        case .II:  return (-1,  1)
        case .III: return (-1, -1)
        case .IV:  return ( 1, -1)
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
  
  func diagonalRect(using point: CGPoint) -> CGRect {
    let delta = delta(to: point)
    
    var origin: CGPoint
    switch quadrant(of: point) {
      case .I:
        origin = self
      case .II:
        origin = CGPoint(x: x + delta.x,
                         y: y)
      case .III:
        origin = CGPoint(x: x + delta.x,
                         y: y + delta.y)
      case .IV:
        origin = CGPoint(x: x,
                         y: y + delta.y)
    }
    
    let absDelta = delta.abs()
    let size = DeltaSize(width: absDelta.x, height: absDelta.y)
    
    return CGRect(origin: origin, size: size)
  }

  func move(by delta: DeltaPoint) -> CGPoint {
    CGPoint(x: x + delta.x, y: y + delta.y)
  }
  
  func opposite() -> DeltaPoint {
    DeltaPoint(x: -x, y: -y)
  }

  func quadrant(of point: CGPoint) -> Quadrant {
    let delta = delta(from: point)
    
    let signX = delta.x < 0 ? 1 : -1
    let signY = delta.y < 0 ? 1 : -1
    
    return Quadrant(rawValue: (signX, signY))!
  }

}
