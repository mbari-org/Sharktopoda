//
//  WindowData.swift
//  Created for Sharktopoda on 11/25/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVKit

final class WindowData: Identifiable, ObservableObject {
  var _id: String?
  
  var windowKeyInfo: WindowKeyInfo = WindowKeyInfo()
  
  var _frameDuration: CMTime?
  var _fullSize: CGSize?
  var _localizationData: LocalizationData?
  var _player: AVPlayer?
  var _playerView: PlayerView?
  var _sliderView: NSTimeSliderView?
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
  
  var localizationData: LocalizationData {
    get { _localizationData! }
    set { _localizationData = newValue }
  }
  
  var player: AVPlayer {
    get { _player! }
    set { _player = newValue }
  }
  
  var playerView: PlayerView {
    get { _playerView! }
    set { _playerView = newValue }
  }
  
  var sliderView: NSTimeSliderView {
    get { _sliderView! }
    set { _sliderView = newValue }
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
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      self.pause(false)
      self.step(steps)
    }
  }
  
  var currentFrameTime: Int {
    localizationData.frameTime(of: videoControl.currentTime)
  }
  
  func pause(_ withDisplay: Bool = true) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.play(rate: 0.0)
      self.playerView.clear()
      self.localizationData.clearSelected()

      if withDisplay {
        self.displayPaused()
      }
    }
  }
  
  func play(rate: Float) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      
      self.localizationData.clearSelected()
      self.playerDirection = PlayerDirection.at(rate: rate)
      self.playerView.clear(localizations: self.pausedLocalizations())
      self.videoControl.play(rate: rate)
    }
  }
  
  func playBackward() {
    play(rate: -1 * videoControl.previousSpeed)
  }
  
  func playForward() {
    play(rate: videoControl.previousSpeed)
  }
  
  func playerResume(_ direction: WindowData.PlayerDirection) {
    if direction == .paused {
       displayPaused()
    } else {
      play(rate: videoControl.previousDirection.rawValue * videoControl.previousSpeed)
    }
  }

  func seek(elapsedTime: Int) {
    let frameTime = localizationData.frameTime(of: elapsedTime)
    videoControl.seek(elapsedTime: frameTime) { [weak self] done in
      DispatchQueue.main.async {
        self?.displayPaused()
      }
    }
  }
  
  func step(_ steps: Int) {
    let stepTime = currentFrameTime + steps * localizationData.frameDuration
    seek(elapsedTime: stepTime)
  }
  
  var showLocalizations: Bool {
    UserDefaults.standard.bool(forKey: PrefKeys.showAnnotations)
  }
}

extension WindowData {
  func add(localizations controlLocalizations: [ControlLocalization]) {
    let currentFrameNumber = localizationData.frameNumber(of: videoControl.currentTime)

    controlLocalizations
      .map { Localization(from: $0, size: fullSize) }
      .forEach {
        $0.resize(for: playerView.videoRect)
        localizationData.add($0)
        
        guard videoControl.paused else { return }
        guard localizationData.frameNumber(for: $0) == currentFrameNumber else { return }
        
        playerView.display(localization: $0)
      }
  }
  
  func displayPaused() {
    let localizations = pausedLocalizations()
    playerView.display(localizations: localizations)
  }

  func pausedLocalizations() -> [Localization] {
    localizationData.fetch(.paused, at: videoControl.currentTime)
  }
  
  func select(localizationIds ids: [String]) {
    localizationData.select(ids: ids, notifyClient: false)
    
    localizationData.selectedLocalizations.forEach {
      playerView.displayConcept(for: $0)
    }
//    playerView.playerLayer.setNeedsDisplay()
//    playerView.playerLayer.setNeedsLayout()
//    playerView.rootLayer.setNeedsLayout()
    
//    let selectedLocalizations = localizationData.selectedLocalizations
//    playerView.clear(localizations: selectedLocalizations)
//    playerView.display(localizations: selectedLocalizations)
//    selectedLocalizations.forEach {
//      playerView.displayConcept(for: $0)
//    }
  }
}

extension WindowData {
  enum PlayerDirection: Float {
    case backward = -1.0
    case paused = 0.0
    case forward =  1.0
    
    static func at(rate: Float) -> PlayerDirection {
      if rate == 0.0 {
        return .paused
      } else if 0 < rate {
        return .forward
      } else {
        return .backward
      }
    }
    
    func opposite() -> PlayerDirection {
      if self == .paused {
        return .paused
      } else {
        return self == .backward ? .forward : .backward
      }
    }
  }
}
