//
//  AnnotationPreferences.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct AnnotationPreferences: View {
  @AppStorage(PrefKeys.creationCursorSize) private var creationCursorSize: Int = 6
  @AppStorage(PrefKeys.creationCursorColor) private var creationCursorColorHex: String = "#ff0000"
  
  var body: some View {
    VStack {
      HStack {
        Text("Cursor")
          .font(.title3)
        Text("Size: ")
        TextField("", value: $creationCursorSize, formatter: NumberFormatter())
          .frame(width: 50)
          .multilineTextAlignment(.trailing)
        Text("Color: ")
        TextField("", text: $creationCursorColorHex)
          .disableAutocorrection(true)
          .frame(width: 75)
          .multilineTextAlignment(.trailing)
        
        ColorPicker(
          "",
          selection: Binding(
            get: { UserDefaults.standard.color(forKey: PrefKeys.creationCursorColor) },
            set: { newValue in
              UserDefaults.standard.setColor(newValue, forKey: PrefKeys.creationCursorColor)
            }
          )
        )
        .border(.white)
        .frame(width: 16, height: 16)
      }
    }
  }
}

struct AnnotationPreferences_Previews: PreviewProvider {
  static var previews: some View {
    AnnotationPreferences()
  }
}
