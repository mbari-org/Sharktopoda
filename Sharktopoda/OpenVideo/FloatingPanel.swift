//
//  FloatingPanel.swift
//  Created for Sharktopoda on 10/5/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

final class FloatingPanel<Content: View>: NSPanel {
  @Binding var isPresented: Bool
  
  private
  let style: NSWindow.StyleMask = [.nonactivatingPanel, .titled, .resizable, .closable, .fullSizeContentView]
  
  init(view: () -> Content,
       contentRect: NSRect,
       backing: NSWindow.BackingStoreType = .buffered,
       defer deferFlag: Bool = false,
       isPresented: Binding<Bool>) {
    
    // Initialize the binding variable by assigning the whole value via an underscore
    self._isPresented = isPresented
    
    super.init(contentRect: contentRect,
               styleMask: style,
               backing: backing,
               defer: deferFlag)
    
    /// Can be on top of other windows
    isFloatingPanel = true
    level = .floating
    
    /// Can be overlaid in a fullscreen space
    collectionBehavior.insert(.fullScreenAuxiliary)
    
    /// Never show title
    titleVisibility = .hidden
    titlebarAppearsTransparent = true
    
    /// Since no title bar, make moveable by dragging on the background
    isMovableByWindowBackground = true
    
    /// Hide when not in focus
    hidesOnDeactivate = true
    
    /// Hide traffic lights
    standardWindowButton(.closeButton)?.isHidden = true
    standardWindowButton(.miniaturizeButton)?.isHidden = true
    standardWindowButton(.zoomButton)?.isHidden = true
    
    /// Sets animations accordingly
    animationBehavior = .utilityWindow
    
    /// Set content view with safe area ignored (bc title bar still interferes with the geometry)
    contentView = NSHostingView(rootView: view()
      .ignoresSafeArea()
      .environment(\.openUrlPanel, self))
  }
  
  
  var body: some View {
    Text("CxInc")
  }
  
  /// Close automatically when out of focus, e.g. outside click
  override func resignMain() {
    super.resignMain()
    close()
  }

  /// Close and toggle presentation to matches the current panel state
  override func close() {
    super.close()
    isPresented = false
  }
  
  /// Text input inside the panel can receive focus
  override var canBecomeKey: Bool { true }
  override var canBecomeMain: Bool { true }
}

private struct FloatingPanelKey: EnvironmentKey {
  static let defaultValue: NSPanel? = nil
}

extension EnvironmentValues {
  var openUrlPanel: NSPanel? {
    get { self[FloatingPanelKey.self] }
    set { self[FloatingPanelKey.self] = newValue }
  }
}
