//
//  RandomAccessCollection.swift
//  Created for Sharktopoda on 10/7/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

public extension RandomAccessCollection where Element: Comparable {
  func binarySearch(for value: Element, in range: Range<Index>? = nil) -> Index? {
    let range = range ?? startIndex..<endIndex

    guard range.lowerBound < range.upperBound else {
      return nil
    }

    let size = distance(from: range.lowerBound, to: range.upperBound)
    let middle = index(range.lowerBound, offsetBy: size / 2)

    if self[middle] == value {
      return middle
    } else if self[middle] > value {
      return binarySearch(for: value, in: range.lowerBound..<middle)
    } else {
      return binarySearch(for: value, in: index(after: middle)..<range.upperBound)
    }
  }
}
