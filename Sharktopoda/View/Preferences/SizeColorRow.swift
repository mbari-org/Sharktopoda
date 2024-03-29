//
//  SizeColorRow.swift
//  Created for Sharktopoda on 9/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct SizeColorRow: View {
  private var label: String
  @Binding private var size: Int
  @Binding private var colorHex: String
  private var colorPrefKey: String
  
  private var hexFont = Font.system(size: 12).monospaced()
  
  var body: some View {
    HStack {
      HStack {
        Spacer()
        Text(label)
          .font(.title3)
      }
      .frame(width: 60)
      .padding(.trailing, 10)

      Text("Size: ")
      TextField("", value: $size, formatter: NumberFormatter())
        .frame(width: 60)
        .multilineTextAlignment(.trailing)

      ColorPicker(
        "Color: ",
        selection: Binding(
          get: { Color(hex: colorHex)! },
          set: { newValue in
            UserDefaults.standard.setColor(newValue, forKey: colorPrefKey)
          }
        )
      )
      .padding(.leading, 30)

      Text(colorHex)
        .padding(.leading, 5)
        .font(hexFont)
    }
  }
  
  init(label: String, size: Binding<Int>, colorHex: Binding<String>, prefKey: String) {
    self.label = label
    self._size = size
    self._colorHex = colorHex
    self.colorPrefKey = prefKey
  }
}

struct SizeColorRow_Previews: PreviewProvider {
  static var previews: some View {
//    SizeColorRow(10, .red)
    Text("CxTBD")
  }
}
