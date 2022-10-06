//
//  FloatingPanelModifier.swift
//  Created for Sharktopoda on 10/5/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

/// Add  to a view hierarchy
struct FloatingPanelModifier<PanelContent: View>: ViewModifier {
  /// Determines wheter the panel should be presented or not
  @Binding var isShowing: Bool
  
  /// Starting size
  var contentRect: CGRect
  
  /// Holds the panel content's view closure
  @ViewBuilder let view: () -> PanelContent
  
  /// Stores the panel instance with the same generic type as the view closure
  @State var panel: FloatingPanel<PanelContent>?
  
  func body(content: Content) -> some View {
    content
      .onAppear {
        panel = FloatingPanel(view: view, contentRect: contentRect, isPresented: $isShowing)
        panel?.center()
        if isShowing {
          show()
        }
      }
      .onDisappear {
        panel?.close()
        panel = nil
      }
      .onChange(of: isShowing) { value in
        value ? show() : panel?.close()
      }
  }
  
  /// Present and make key window
  func show() {
    panel?.orderFront(nil)
    panel?.makeKey()
  }
}

