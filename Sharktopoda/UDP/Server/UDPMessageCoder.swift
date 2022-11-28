//
//  UDPMessageCoder.swift
//  Created for Sharktopoda on 11/10/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct UDPMessageCoder {
  static var encoder: JSONEncoder = {
    let encoder = JSONEncoder()
    let outputFormatting: JSONEncoder.OutputFormatting = [.sortedKeys, .withoutEscapingSlashes]
    encoder.outputFormatting = outputFormatting
    return encoder
  }()
  static var decoder = JSONDecoder()
  
  static func encode<T>(_ value: T) throws -> Data where T : Encodable {
    try UDPMessageCoder.encoder.encode(value)
  }
  
  static func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
    try UDPMessageCoder.decoder.decode(type, from: data)
  }
}
