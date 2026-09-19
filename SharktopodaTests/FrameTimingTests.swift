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
  /// Exact 60 fps
  private let fps60 = FrameTiming(frameDuration: CMTime(value: 1, timescale: 60))
  /// Exact 60 fps as 10/600 (common MOV timescale)
  private let fps60mov = FrameTiming(frameDuration: CMTime(value: 10, timescale: 600))

  func testFfmpegCeilTable5994() {
    let cases: [(Int, Int)] = [
      (0, 0), (1, 1), (16, 1), (17, 2), (33, 2), (34, 3),
      (50, 3), (51, 4), (250, 15), (251, 16), (267, 17),
    ]
    for (ms, frame) in cases {
      XCTAssertEqual(fps5994.frame(forMillis: ms), frame, "ms=\(ms)")
    }
  }

  func testFfmpegCeilTable60() {
    let cases: [(Int, Int)] = [
      (0, 0), (1, 1), (16, 1), (17, 2), (33, 2), (34, 3),
      (1000, 60), (1001, 61),
    ]
    for (ms, frame) in cases {
      XCTAssertEqual(fps60.frame(forMillis: ms), frame, "60 fps ms=\(ms)")
      XCTAssertEqual(fps60mov.frame(forMillis: ms), frame, "60 mov ms=\(ms)")
    }
  }

  /// Boundary from i2MAP 59.94 field test (issue-56 17ms skew investigation).
  func testI2MAPBoundaryCeilAndEmit() {
    let cases: [(Int, Int, Int)] = [
      // requestT, ceilFrame, canonicalEmit floor(PTS)
      (78728, 4719, 78728),
      (78729, 4720, 78745),
      (78745, 4720, 78745),
      (78746, 4721, 78762),
    ]
    for (ms, frame, emit) in cases {
      XCTAssertEqual(fps5994.frame(forMillis: ms), frame, "ceil ms=\(ms)")
      XCTAssertEqual(fps5994.millis(ofFrame: frame), emit, "emit frame=\(frame)")
      XCTAssertEqual(fps5994.frame(forMillis: emit), frame, "round-trip emit=\(emit)")
    }
    // Same content at same T: 78729 and 78745 both select frame 4720 — not 78728↔78745.
    XCTAssertEqual(fps5994.frame(forMillis: 78729), fps5994.frame(forMillis: 78745))
    XCTAssertNotEqual(fps5994.frame(forMillis: 78728), fps5994.frame(forMillis: 78745))
  }

  func testRoundTripMillisOfFrame() {
    for timing in [fps5994, fps2997, fps25, fps60, fps60mov] {
      for k in 0...60 {
        let ms = timing.millis(ofFrame: k)
        XCTAssertEqual(timing.frame(forMillis: ms), k, "k=\(k) ms=\(ms)")
        XCTAssertEqual(timing.frame(forMillis: ms + 1), k + 1, "k=\(k) ms+1")
      }
    }
  }

  func testDisplayedAtExactPTS() {
    for timing in [fps5994, fps2997, fps25, fps60, fps60mov] {
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

  func testResolveFrameDurationFrom5994Samples() throws {
    let d = CMTime(value: 1001, timescale: 60000)
    let times = (0..<30).map { CMTimeMultiply(d, multiplier: Int32($0)) }
    let resolved = try FrameTiming.resolveFrameDuration(presentationTimes: times, naturalTimeScale: 60000)
    XCTAssertEqual(resolved, d)
  }

  func testResolveFrameDurationFrom60SamplesOn600Timescale() throws {
    let d = CMTime(value: 10, timescale: 600)
    let times = (0..<30).map { CMTimeMultiply(d, multiplier: Int32($0)) }
    let resolved = try FrameTiming.resolveFrameDuration(presentationTimes: times, naturalTimeScale: 600)
    XCTAssertEqual(resolved.value, 10)
    XCTAssertEqual(resolved.timescale, 600)
  }

  func testResolveFrameDurationRejectsVFR() {
    let times: [CMTime] = [
      .zero,
      CMTime(value: 10, timescale: 600),
      CMTime(value: 25, timescale: 600),
      CMTime(value: 50, timescale: 600),
      CMTime(value: 55, timescale: 600),
      CMTime(value: 90, timescale: 600),
    ]
    XCTAssertThrowsError(try FrameTiming.resolveFrameDuration(presentationTimes: times)) { error in
      guard case FrameTimingError.variableFrameRate = error else {
        return XCTFail("expected variableFrameRate, got \(error)")
      }
    }
  }

  func testResolveFrameDurationAllowsOccasionalJitterIfDominant() throws {
    var times = (0..<20).map { CMTime(value: CMTimeValue($0 * 10), timescale: 600) }
    // One irregular gap mid-stream (still <20% of deltas)
    times[10] = CMTime(value: 10 * 10 + 5, timescale: 600)
    for i in 11..<20 {
      times[i] = CMTime(value: CMTimeValue(i * 10 + 5), timescale: 600)
    }
    let resolved = try FrameTiming.resolveFrameDuration(presentationTimes: times, naturalTimeScale: 600)
    XCTAssertEqual(resolved, CMTime(value: 10, timescale: 600))
  }
}
