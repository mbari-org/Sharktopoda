//
//  OpenUrlPanel.swift
//  Created for Sharktopoda on 10/6/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct OpenUrlPanel: View {
  @Binding var showPanel: Bool
  
  @State var path: String = ""

  var body: some View {
    VStack {
      Text("Open URL")
        .font(.title)
        .foregroundColor(.primary)
        .padding(.top, 20)
      
      Divider()
      
      HStack {
        Text("URL:")
        TextField("", text: $path)
      }
      .padding(EdgeInsets(top: 20, leading: 40, bottom: 10, trailing: 40))
      .onSubmit {
        path.isEmpty ? showPanel = false : submit()
      }
      
      HStack {
        Button {
          showPanel = false
        } label: {
          Text("Cancel")
        }
        .buttonStyle(.bordered)
        .padding(.trailing, 40)
        
        Button {
          submit()
        } label: {
          Text("Open")
        }
        .buttonStyle(.borderedProminent)
        .disabled(path.isEmpty)
      }
      .padding()
      
      Spacer()
    }
  }
  
  func submit() {
    showPanel = false

    guard let url = URL(string: path) else {
      alert(path: path, error: OpenVideoError.invalidUrl)
      return
    }
    
    do {
      if !(try url.checkResourceIsReachable()) {
        alert(path: url.path, error: OpenVideoError.invalidUrl)
        return
      }
    } catch {
      alert(path: url.path, error: OpenVideoError.unknown(error.localizedDescription))
      return
    }
    
    if let error = VideoWindow.open(id: url.path, url: url) as? OpenVideoError {
      alert(path: url.path, error: error)
      return
    }
  }
  
  func alert(path: String, error: OpenVideoError) {
    let openAlert = OpenAlert(path: path, error: error)
    openAlert.show()
  }
}

//struct OpenUrlPanel_Previews: PreviewProvider {
//  @State private var showingPanel = false
//  static var previews: some View {
//    OpenUrlPanel(isShowing: $showingPanel)
//  }
//}
