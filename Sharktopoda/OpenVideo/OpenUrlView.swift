//
//  OpenURLView.swift
//  Created for Sharktopoda on 10/5/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct OpenUrlView: View {
  @State var showingPanel = false
  @State var url: String = ""
  
  private let panelRect = CGRect(x: 0, y: 0, width: 600, height: 180)
  
  private(set) static var shared = OpenUrlView()
  private init() { }
  
  var body: some View {
    Button("Open URL...") {
      showingPanel.toggle()
    }
    .floatingPanel(isPresented: $showingPanel, contentRect: panelRect) {
      VStack {
        Text("Open URL")
          .font(.title)
          .foregroundColor(.primary)
          .padding(.top, 20)
        
        Divider()
        
        HStack {
          Text("URL:")
          TextField("", text: $url)
        }
        .padding(EdgeInsets(top: 20, leading: 40, bottom: 10, trailing: 40))
        
        HStack {
          Button {
            
          } label: {
            Text("Cancel")
          }
          .buttonStyle(.bordered)
          .padding(.trailing, 40)
          
          Button {
            print(self)
            print("open: \(url)")
          } label: {
            Text("Open")
          }
          .buttonStyle(.bordered)
        }
        .padding()
        
        Spacer()
      }
    }
  }
}

struct OpenUrlView_Previews: PreviewProvider {
  static var previews: some View {
    OpenUrlView.shared
  }
}
