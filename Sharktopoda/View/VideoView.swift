//
//  VideoView.swift
//  Created for Sharktopoda on 9/14/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct VideoView: View {
  var body: some View {
    VStack {
      Text("Video")
        .frame(minWidth: 700, minHeight: 300)
      
      Text("Hideable Control")
    }
    .padding()
  }
}

struct VideoView_Previews: PreviewProvider {
  static var previews: some View {
    VideoView()
  }
}
