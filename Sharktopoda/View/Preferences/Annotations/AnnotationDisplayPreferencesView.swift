//
//  AnnotationDisplayPreferencesView.swift
//  Created for Sharktopoda on 9/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct AnnotationDisplayPreferencesView: View {
  @AppStorage(PrefKeys.displayBorderSize)
  private var displayBorderSize: Int = UserDefaults.standard.integer(forKey: PrefKeys.displayBorderSize)
  
  @AppStorage(PrefKeys.displayBorderColor)
  private var displayBorderColorHex: String = UserDefaults.standard.hexColor(forKey: PrefKeys.displayBorderColor)
  
  @AppStorage(PrefKeys.displayTimeWindow)
  private var displayTimeWindow: Int = UserDefaults.standard.integer(forKey: PrefKeys.displayTimeWindow)
  
  @AppStorage(PrefKeys.displayUseDuration)
  private var displayUseDuration: Bool = false

  var body: some View {
    Divider()
    
    HStack {
      Text("Annotation Display")
        .font(.title2)
      Spacer()
    }
    .padding(5)
    
    SizeColorRow(
      label: "Border",
      size: $displayBorderSize,
      colorHex: $displayBorderColorHex,
      prefKey: PrefKeys.displayBorderColor
    )
    
    HStack {
      Text("Time Window")
        .font(.title3)
        .frame(width: 120)
        .padding(.leading, 28)
      TextField("", value: $displayTimeWindow, formatter: NumberFormatter())
        .frame(width: 60)
        .multilineTextAlignment(.trailing)
        .padding(.leading, 40)
      Text("millis")
        .padding(.trailing, 40)
      Toggle("  Use Duration", isOn: $displayUseDuration)
        .toggleStyle(.checkbox)
      Spacer()
    }
  }
}

struct AnnotationDisplyPreferencesView_Previews: PreviewProvider {
  static var previews: some View {
    AnnotationDisplayPreferencesView()
  }
}
