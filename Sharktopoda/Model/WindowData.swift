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
  
  @Published var playerTime: Int = 0
  @Published var playerDirection: PlayerDirection = .paused

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

extension WindowData {
  func advance(steps: Int) {
    let pausedLocalizations = pausedLocalizations()
    
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      
      self.localizations.clearSelected()
      self.playerView.clear()
      self.videoControl.step(steps)
      self.playerView.display(localizations: pausedLocalizations)
    }
  }

  func pause() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.play(rate: 0.0)
      self.playerView.clear()
      self.playerView.display(localizations: self.pausedLocalizations())
    }
  }
  
  func play() {
    play(rate: videoControl.previousRate)
  }
  
  func play(rate: Float) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.playerDirection = PlayerDirection.at(rate: rate)
      self.playerView.clear(localizations: self.pausedLocalizations())
      self.videoControl.play(rate: rate)
    }
  }
  
  var previousDirection: PlayerDirection {
    PlayerDirection.at(rate: videoControl.previousRate)
  }
  
  func reverse() {
    play(rate: -1 * videoControl.previousRate)
  }
  
  var showLocalizations: Bool {
    UserDefaults.standard.bool(forKey: PrefKeys.showAnnotations)
  }
}

extension WindowData {
  func add(localizations controlLocalizations: [ControlLocalization]) {
    let currentFrameNumber = localizations.frameNumber(elapsedTime: videoControl.currentTime)

    controlLocalizations
      .map { Localization(from: $0, size: fullSize) }
      .forEach {
        $0.resize(for: playerView.videoRect)
        localizations.add($0)
        
        guard videoControl.paused else { return }
        guard localizations.frameNumber(for: $0) == currentFrameNumber else { return }
        
        playerView.display(localization: $0)
      }
  }

  func pausedLocalizations() -> [Localization] {
    guard videoControl.paused else { return [] }
    return localizations.fetch(.paused, at: videoControl.currentTime)
  }
}

extension WindowData {
  enum PlayerDirection: Int {
    case reverse = -1
    case paused = 0
    case forward =  1
    
    static func at(rate: Float) -> PlayerDirection {
      if rate == 0.0 {
        return .paused
      } else if 0 < rate {
        return .forward
      } else {
        return .reverse
      }
    }
    
    func opposite() -> PlayerDirection {
      if self == .paused {
        return .paused
      } else {
        return self == .reverse ? .forward : .reverse
      }
    }
  }
}
