//
//  FrameTimingTests.swift
//  Created for Sharktopoda.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import XCTest
@testable import Sharktopoda

final class FrameTimingTests: XCTestCase {

  /// 59.94 fps
  private let fps5994 = FrameTiming(frameDuration: CMTime(value: 1001, timescale: 60000))
  /// 29.97 fps
  private let fps2997 = FrameTiming(frameDuration: CMTime(value: 1001, timescale: 30000))
  /// 25 fps
  private let fps25 = FrameTiming(frameDuration: CMTime(value: 1, timescale: 25))

  func testFfmpegCeilTable5994() {
    let cases: [(Int, Int)] = [
      (0, 0), (1, 1), (16, 1), (17, 2), (33, 2), (34, 3),
      (50, 3), (51, 4), (250, 15), (251, 16), (267, 17),
    ]
    for (ms, frame) in cases {
      XCTAssertEqual(fps5994.frame(forMillis: ms), frame, "ms=\(ms)")
    }
  }

  func testRoundTripMillisOfFrame() {
    for timing in [fps5994, fps2997, fps25] {
      for k in 0...60 {
        let ms = timing.millis(ofFrame: k)
        XCTAssertEqual(timing.frame(forMillis: ms), k, "k=\(k) ms=\(ms)")
        XCTAssertEqual(timing.frame(forMillis: ms + 1), k + 1, "k=\(k) ms+1")
      }
    }
  }

  func testDisplayedAtExactPTS() {
    for timing in [fps5994, fps2997, fps25] {
      for k in 0...30 {
        let pts = timing.time(ofFrame: k)
        XCTAssertEqual(timing.frame(displayedAt: pts), k)
        if k > 0 {
          let before = CMTimeSubtract(pts, CMTime(value: 1, timescale: timing.frameDuration.timescale))
          XCTAssertEqual(timing.frame(displayedAt: before), k - 1)
        }
      }
    }
  }

  func testCMTimeMillisTruncatesNotRounds() {
    let pts = CMTime(value: 1001, timescale: 60000) // 16.6833 ms
    XCTAssertEqual(pts.millis, 16)
    let pts2 = CMTime(value: 4004, timescale: 60000) // 66.7333 ms
    XCTAssertEqual(pts2.millis, 66)
  }

  func testMillisOfFrameMatchesTruncatedPTS() {
    for k in 0...40 {
      let pts = fps5994.time(ofFrame: k)
      XCTAssertEqual(fps5994.millis(ofFrame: k), pts.millis)
    }
  }
}
