//
//  VideoInfoContent.swift
//  Created for Sharktopoda on 9/22/25.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation
import Combine
import Foundation
import SwiftUI

struct VideoInfoContent: View {
  let windowData: WindowData

  @State private var currentTime: CMTime = .zero
  private let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()

  var body: some View {
    Grid(alignment: .trailing, verticalSpacing: 10) {
      infoRow("Video UUID:", windowData.id)
      infoRow("URL or file:", urlText)
      infoRow("Total Localizations:", "\(windowData.localizationData.storage.count)")
      infoRow("Current Elapsed Time:", currentTimeText)
      infoRow("Video Resolution:", resolutionText)
      infoRow("Video Duration:", durationText)
      infoRow("Frame Rate:", frameRateText)
    }
    .padding(10)
    .frame(width: 625)
    .onReceive(timer) { _ in
      currentTime = windowData.videoControl.currentTime
    }
  }

  private var currentTimeText: String {
    "\(currentTime.millis) ms (\(currentTime.humanTime))"
  }

  private var durationText: String {
    let duration = windowData.videoAsset.duration
    return "\(duration.millis) ms (\(duration.humanTime))"
  }

  private var frameRateText: String {
    let frameDuration = windowData.videoAsset.frameDuration
    return "\(frameDuration.timescale)/\(frameDuration.value)"
  }

  private var resolutionText: String {
    let size = windowData.videoAsset.fullSize
    return "\(Int(size.width)) × \(Int(size.height))"
  }

  private var urlText: String {
    let url = windowData.videoAsset.url
    return url.isFileURL ? url.path : url.absoluteString
  }

  private func infoRow(_ label: String, _ value: String) -> some View {
    GridRow {
      Text(label)
        .foregroundStyle(.secondary)
      Text(value)
        .gridColumnAlignment(.leading)
        .textSelection(.enabled)
        .fixedSize(horizontal: false, vertical: true)
    }
  }
}
