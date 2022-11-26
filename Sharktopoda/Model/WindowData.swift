//
//  WindowData.swift
//  Created for Sharktopoda on 11/25/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVKit

final class WindowData: ObservableObject {
  var _id: String?
  
  var _frameDuration: CMTime?
  var _fullSize: CGSize?
  var _localizations: Localizations?
  var _player: AVPlayer?
  var _playerView: PlayerView?
  var _videoAsset: VideoAsset?
  var _videoControl: VideoControl?

  var id: String {
    get { _id! }
    set { _id = newValue }
  }
  
  var frameDuration: CMTime {
    get { _frameDuration! }
    set { _frameDuration = newValue }
  }
  
  var fullSize: CGSize {
    get { _fullSize! }
    set { _fullSize = newValue }
  }
  
  var localizations: Localizations {
    get { _localizations! }
    set { _localizations = newValue }
  }
  
  var player: AVPlayer {
    get { _player! }
    set { _player = newValue }
  }
  
  var playerView: PlayerView {
    get { _playerView! }
    set { _playerView = newValue }
  }
  
  var videoAsset: VideoAsset {
    get { _videoAsset! }
    set { _videoAsset = newValue }
  }

  var videoControl: VideoControl {
    get { _videoControl! }
    set { _videoControl = newValue }
  }
}
