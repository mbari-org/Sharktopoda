//
//  AnnotationPreferences.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct AnnotationPreferences: View {
  var bg: Color = Color.red
  
  @AppStorage(PrefKeys.creationCursorSize) private var creationCursorSize: Int = 6
//  @AppStorage(PrefKeys.creationCursorColor) private var creationCursorColor: Color = Color.red
  
  var body: some View {
//    ColorPicker()
    VStack {
      HStack {
        Text("Cursor")
          .font(.title3)
        Text("Size: ")
        TextField("", value: $creationCursorSize, formatter: NumberFormatter())
          .frame(width: 50)
        Text("Color: ")
//        TextField("", value: $creationCursorColor, formatter: NumberFormatter())
//          .frame(width: 50)
      }
    }
  }
}

struct AnnotationPreferences_Previews: PreviewProvider {
  static var previews: some View {
    AnnotationPreferences()
  }
}
