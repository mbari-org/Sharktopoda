# Changelog

## [2.2.1] - 2026-09-21

### Added

- Release build/signing helpers

### Changed

- Frame timing / `elapsedTimeMillis` handling generalized for arbitrary frame rates
- Queue inbound UDP commands during async video loading
- Frame grab and playback use encoded-pixel aperture so geometry aligns with MBARI Beholder captures
- UDP debug logging distinguishes incoming and outbound control traffic more clearly

### Fixed

- Localization had incorrect size/position/color on display after an initial video open command
    - This was likely a regression from other work in the 2.2.0 release or this release as it was not reported as a previous issue

## [2.2.0] - 2026-09-16

### Changed

- Modify presentation timestamp frame selection to match `ffmpeg -ss -i`
- Remove code signature requirement for local debug
- Minor color change to video control play buttons

### Fixed

- Fix issue [50](https://github.com/mbari-org/Sharktopoda/issues/50)
    - See also vars-feedback issue [56](https://github.com/mbari-org/vars-feedback/issues/56)
- Fix open file/url dialog during video playback

### Note

As a macOS application, Sharktopoda uses Apple's AVFoundation framework for video operations. As an MBARI application, Sharktopoda interacts with other MBARI VARS systems. Those other systems utilize ffmpeg for similar video operations. Importantly, AVFoundation and ffmpeg utilize different strategies when selecting a frame for a given presentation frame timestamp (PFT):

- AVFoundation:
    - the last frame whose PTS is ≤ T
    - So AVFoundation picks the frame already due at or before T (floor)

- ffmpeg -ss -i:
    - the first frame whose PTS is ≥ T
    - So ffmpeg picks the next frame at or after T (ceil)

Neither strategy is right or wrong, per se. However, as detailed in issue [50](https://github.com/mbari-org/Sharktopoda/issues/50), MBARI systems need consistency in presentation frame selection per timestamp. Changes in this Sharktopoda release modify timestamp handling in a manner that results in ffmpeg semantics, so now Sharktopoda AVFoundation usage matches ffmpeg as to which frame is selected at any given timestamp.

The prior PTS selection difference always resulted in a potential mismatch of at most one frame. This was primarily noticeable on annotations of fast moving transects.

## [2.1.1] - 2026-02-12

### Added

- README

Fix for errors with resource closure and time sync on Tahoe

## [2.1.0] - 2023-10-17

### Added

- Show Annotations switch on video control (per video window)
- Volume control

### Changed

- Resize time slider

## [2.0.3] - 2023-02-15

### Changed

- Window background color
- Window title to file name
- Display human time in video control
- After seek, continue play state
- Display spanned locations rather than paused

### Fixed

- Play/pause

## [2.0.2] - 2023-02-13

### Fixed

- Issue [39](https://github.com/mbari-org/Sharktopoda/issues/39)
- Issue [40](https://github.com/mbari-org/Sharktopoda/issues/40)

## [2.0.1] - 2023-01-24

### Added

- Border size & color for selection vs creation

### Fixed

- Issue [35](https://github.com/mbari-org/Sharktopoda/issues/35)
- Fix flash on step


## [2.0.0] - 2023-01-18

### Initial Release

[2.2.0]: https://github.com/mbari-org/Sharktopoda/compare/2.1.1...2.2.0
[2.1.1]: https://github.com/mbari-org/Sharktopoda/compare/2.1.0...2.1.1
[2.1.0]: https://github.com/mbari-org/Sharktopoda/compare/2.0.3...2.1.0
[2.0.3]: https://github.com/mbari-org/Sharktopoda/compare/2.0.2...2.0.3
[2.0.2]: https://github.com/mbari-org/Sharktopoda/compare/2.0.1...2.0.2
[2.0.1]: https://github.com/mbari-org/Sharktopoda/compare/2.0.0...2.0.1
[2.0.0]: https://github.com/mbari-org/Sharktopoda/releases/tag/2.0.0
