//
//  AnnotationDisplayPreferencesView.swift
//  Created for Sharktopoda on 9/16/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct AnnotationDisplayPreferencesView: View {
  @AppStorage(PrefKeys.displayBorderSize)
  private var displayBorderSize: Int = AnnotationPreferencesView.defaultSize
  
  @AppStorage(PrefKeys.displayBorderColor)
  private var displayBorderColorHex: String = AnnotationPreferencesView.defaultColorHex
  
  @AppStorage(PrefKeys.displayTimeWindow)
  private var displayTimeWindow: Int = 30
  
  @AppStorage(PrefKeys.displayUseDuration)
  private var displayUseDuration: Bool = false
  
  var body: some View {
    Divider()
    
    HStack {
      Text("Annotation Display")
        .font(.title)
      Spacer()
    }
    .padding(5)
    
    SizeColorRow(
      label: "Border",
      size: $displayBorderSize,
      colorHex: displayBorderColorHex,
      prefKey: PrefKeys.displayBorderColor
    )
    
    HStack {
      Text("Time Window")
        .font(.title3)
        .frame(width: 120)
        .padding(.leading, 37)
      TextField("", value: $displayTimeWindow, formatter: NumberFormatter())
        .frame(width: 60)
        .multilineTextAlignment(.trailing)
        .padding(.leading, 38)
      //        .frame(width: 30)
      ////        .frame(width: 30)
      ////      Text("millis")
      ////        .padding(.trailing, 50)
      ////      Toggle("  Use Duration", isOn: $displayUseDuration)
      ////        .toggleStyle(.checkbox)
      Spacer()
    }
    //    .padding(.trailing, 30)
    
  }
}

struct AnnotationDisplyPreferencesView_Previews: PreviewProvider {
  static var previews: some View {
    AnnotationDisplayPreferencesView()
  }
}
