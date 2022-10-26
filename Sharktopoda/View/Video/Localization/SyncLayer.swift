//
//  SyncLayer.swift
//  Created for Sharktopoda on 10/24/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AppKit
import AVFoundation

final class SyncLayer: AVSynchronizedLayer {
  var fadeInAnimation: CABasicAnimation
  var fadeOutAnimation: CABasicAnimation
  
  var staticLayer: LocalizationLayer?
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) not implemented")
  }

  init(playerItem: AVPlayerItem, elapsedTime: Int, transitionTime: Int, duration: Int) {
    // Animations
    let fadeDuration = CMTime.fromMillis(transitionTime).seconds

    let fadeInTime = CMTime.fromMillis(elapsedTime - transitionTime).seconds
    let fadeOutTime = CMTime.fromMillis(elapsedTime + duration).seconds

    fadeInAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
    fadeInAnimation.beginTime = 0 < fadeInTime ? fadeInTime : AVCoreAnimationBeginTimeAtZero
    fadeInAnimation.fromValue = 0.0
    fadeInAnimation.toValue = 1.0
    fadeInAnimation.duration = fadeDuration
    fadeInAnimation.isRemovedOnCompletion = false
    
    fadeOutAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
    fadeOutAnimation.beginTime = fadeOutTime
    fadeOutAnimation.fromValue = 1.0
    fadeOutAnimation.toValue = 0.0
    fadeOutAnimation.duration = fadeDuration
    fadeOutAnimation.isRemovedOnCompletion = false

    super.init()
    
    self.playerItem = playerItem

    backgroundColor = .clear
  }
  
  func attach(staticLayer: LocalizationLayer) {
    self.staticLayer = staticLayer
    
    frame = staticLayer.frame

    staticLayer.add(fadeInAnimation, forKey: nil)
    staticLayer.add(fadeOutAnimation, forKey: nil)
    
    addSublayer(staticLayer)
  }
  
  func detach() {
    staticLayer?.removeAllAnimations()
    staticLayer?.removeFromSuperlayer()
    staticLayer = nil
  }
  
}
