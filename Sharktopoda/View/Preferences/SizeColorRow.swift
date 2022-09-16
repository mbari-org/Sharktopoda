//
//  SizeColorRow.swift
//  Created for Sharktopoda on 9/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct SizeColorRow: View {
  private var name: String
  @Binding var size: Int
  @Binding var colorHex: String
  private var colorPrefKey: String
  
  var body: some View {
    HStack {
      Text(name)
        .font(.title3)
      Text("Size: ")
      TextField("", value: $size, formatter: NumberFormatter())
        .frame(width: 50)
        .multilineTextAlignment(.trailing)
      Text("Color: ")
      TextField("", text: $colorHex)
        .disableAutocorrection(true)
        .frame(width: 75)
        .multilineTextAlignment(.trailing)
      
      ColorPicker(
        "",
        selection: Binding(
          get: { UserDefaults.standard.color(forKey: colorPrefKey) },
          set: { newValue in
            UserDefaults.standard.setColor(newValue, forKey: colorPrefKey)
          }
        )
      )
      .frame(width: 16, height: 16)
      .border(.white)
    }
  }
  
  init(name: String, size: Binding<Int>, hexColor: Binding<String>, prefKey: String) {
    self.name = name
    self._size = size
    self._colorHex = hexColor
    self.colorPrefKey = prefKey
  }
}

struct SizeColorRow_Previews: PreviewProvider {
  static var previews: some View {
//    SizeColorRow(10, .red)
    Text("CxInc")
  }
}
