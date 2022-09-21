//
//  DefaultValue.swift
//  Created for Sharktopoda on 9/21/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

protocol DefaultValue {
  associatedtype Value: Decodable
  static var defaultValue: Value { get }
}

@propertyWrapper
struct Default<T: DefaultValue> {
  var wrappedValue: T.Value
}

extension Default: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    wrappedValue = (try? container.decode(T.Value.self)) ?? T.defaultValue
  }
}

extension KeyedDecodingContainer {
  func decode<T>(_ type: Default<T>.Type, forKey key: Key) throws -> Default<T> where T: DefaultValue {
    //Determine the missing key and provide the default value
    (try decodeIfPresent(type, forKey: key)) ?? Default(wrappedValue: T.defaultValue)
  }
}

extension Double {
  struct PlaybackRate: DefaultValue {
    static var defaultValue = 1.0
  }
}

extension String {
  struct Localhost: DefaultValue {
    static var defaultValue = "localhost"
  }
  struct Unknown: DefaultValue {
    static var defaultValue = "unknown"
  }
}