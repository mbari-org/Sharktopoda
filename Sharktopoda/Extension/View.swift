//
//  View.swift
//  Created for Sharktopoda on 10/5/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

extension View {
  /** Present a ``FloatingPanel`` in SwiftUI fashion
   - Parameter isPresented: A boolean binding that keeps track of the panel's presentation state
   - Parameter contentRect: The initial content frame of the window
   - Parameter content: The displayed content
   **/
  func floatingPanel<Content: View>(isPresented: Binding<Bool>,
                                    contentRect: CGRect,
                                    @ViewBuilder content: @escaping () -> Content) -> some View {
    self.modifier(FloatingPanelModifier(isShowing: isPresented, contentRect: contentRect, view: content))
  }
}
