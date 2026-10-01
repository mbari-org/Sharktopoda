//
//  ControlResponseStateTests.swift
//  Created for Sharktopoda.
//
//  Apache License 2.0 — See project LICENSE file
//

import XCTest
@testable import Sharktopoda

final class ControlResponseStateTests: XCTestCase {

  private func json(_ response: ControlResponse) throws -> [String: Any] {
    let object = try JSONSerialization.jsonObject(with: response.data())
    return try XCTUnwrap(object as? [String: Any])
  }

  func testPlayStateFromRate() {
    typealias PlayState = ControlResponseState.PlayState
    XCTAssertEqual(PlayState(rate: 0.0), .paused)
    XCTAssertEqual(PlayState(rate: 1.0), .playing)
    XCTAssertEqual(PlayState(rate: 2.0), .forward)
    XCTAssertEqual(PlayState(rate: 0.5), .forward)
    XCTAssertEqual(PlayState(rate: -1.0), .reverse)
    XCTAssertEqual(PlayState(rate: -0.5), .reverse)
  }

  func testPlayingResponseJSON() throws {
    let dict = try json(ControlResponseState(rate: 1.0, elapsedTimeMillis: 12345))
    XCTAssertEqual(Set(dict.keys), ["response", "status", "state", "rate", "elapsedTimeMillis"])
    XCTAssertEqual(dict["response"] as? String, "request player state")
    XCTAssertEqual(dict["status"] as? String, "ok")
    XCTAssertEqual(dict["state"] as? String, "playing")
    XCTAssertEqual(dict["rate"] as? Double, 1.0)
    XCTAssertEqual(dict["elapsedTimeMillis"] as? Int, 12345)
  }

  func testStateStrings() throws {
    let cases: [(Float, String)] = [
      (0.0, "paused"), (1.0, "playing"), (2.0, "shuttling forward"), (-2.0, "shuttling reverse"),
    ]
    for (rate, expected) in cases {
      let dict = try json(ControlResponseState(rate: rate, elapsedTimeMillis: 0))
      XCTAssertEqual(dict["status"] as? String, "ok")
      XCTAssertEqual(dict["state"] as? String, expected)
      XCTAssertEqual(dict["rate"] as? Double, Double(rate))
    }
  }

  func testFailedResponseJSON() throws {
    let failed = ControlResponseFailed(response: .state, cause: "No video for uuid")
    let dict = try json(failed)
    XCTAssertEqual(dict["response"] as? String, "request player state")
    XCTAssertEqual(dict["status"] as? String, "failed")
    XCTAssertEqual(dict["cause"] as? String, "No video for uuid")
    XCTAssertNil(dict["state"])
  }
}
