# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Sharktopoda is a native macOS video player built with Swift/SwiftUI for viewing, creating, and editing rectangular localizations (bounding boxes) on video. It is designed for marine biology research at MBARI and communicates with external annotation/ML applications via a UDP-based JSON protocol.

## Build & Run

This is an Xcode project (no SPM or CocoaPods). Open `Sharktopoda.xcodeproj` in Xcode.

- **Build:** Cmd+B in Xcode, or `xcodebuild -project Sharktopoda.xcodeproj -scheme Sharktopoda build`
- **Run:** Cmd+R in Xcode
- **Tests:** Cmd+U in Xcode, or `xcodebuild -project Sharktopoda.xcodeproj -scheme Sharktopoda test`

Test files are in `SharktopodaTests/` (unit) and `SharktopodaUITests/` (UI).

## Architecture

### Entry Point & State

- `SharktopodaApp.swift` — `@main` SwiftUI app. Creates `SharktopodaData` as root `@StateObject` and injects it via `@EnvironmentObject`.
- `SharktopodaData` — Central observable object holding the UDP server/client, a dictionary of `VideoWindow` instances keyed by normalized UUID, and `OpenedVideos` tracking.
- `WindowData` — Per-video-window state: AVPlayer, VideoAsset, VideoControl, LocalizationData, and published playback state (time, direction, volume).

### UDP Communication (`Sharktopoda/UDP/`)

The app acts as both UDP server (receives commands) and client (sends notifications). Uses Apple's Network framework (`NWListener`, `NWConnection`). Max message size is 4096 bytes, UTF-8 JSON.

- **Server** (`UDP/Server/`): `UDPServer` listens on a user-configured port. Incoming JSON is decoded by `UDPMessageCoder` and dispatched to `ControlRequest/` handlers (e.g., `ControlOpen`, `ControlPlay`, `ControlSeek`, `ControlAddLocalizations`).
- **Client** (`UDP/Client/`): `UDPClient` sends outgoing messages (e.g., `ClientMessageOpenDone`, `ClientMessageCaptureDone`, localization change notifications) to the host/port established via a `connect` command.
- **Responses** (`UDP/Server/ControlResponse/`): Structured response types (`ControlResponseOk`, `ControlResponseFailed`, etc.).

The full protocol spec is in `Requirements/UDP_Remote_Protocol.md`.

### Localization System (`Sharktopoda/Model/`)

Localizations are bounding box annotations on video frames. Coordinates use an "ocean" system (origin upper-left, +X right, +Y down) matching unscaled video pixel coordinates.

- `Localization` — Single annotation: UUID, concept label, time, duration, region (CGRect), color. Renders via `CAShapeLayer`.
- `LocalizationData` — Per-video collection. Sub-components: `LocalizationsStorage` (persistence), `LocalizationsFrames` (time-indexed retrieval), `LocalizationsSelect` (selection state), `LocalizationsMessages` (UDP message handling).

### View Layer (`Sharktopoda/View/`)

- `MainView` — Startup window with open file/URL buttons and UDP port status.
- `VideoWindow` — `NSWindow` subclass per video. Manages AVPlayer lifecycle and window delegate.
- `PlayerView` / `NSPlayerView` — `NSViewRepresentable` bridging AppKit for video rendering + localization overlay. `PlayerMouse` handles mouse interaction for creating/editing/selecting annotations.
- `VideoControlView` — Custom playback controls (play/pause, shuttle, time slider, volume).
- `Preferences` — Settings window with Annotation and Network tabs.

### Extensions (`Sharktopoda/Extension/`)

Key extensions: `Color+Hex` (hex color support), `CMTime+Millis` (millisecond conversion used throughout UDP protocol), `CAShapeLayer` extensions for localization rendering.

## Key Patterns

- UUIDs are normalized to lowercase everywhere via `SharktopodaData.normalizedId()`.
- Videos are identified by UUID, not window reference. All UDP commands reference videos by UUID.
- `UDP.sharktopodaData` is a static reference to the root `SharktopodaData`, used for non-View UDP message handling contexts.
- Localizations must be resized for the current video rect when added (`localization.resize(for: playerView.videoRect)`).
- Playback state changes clear selected localizations and redraw.

## Integration

External apps communicate via the UDP protocol. Pre-built client libraries:
- Java: [vcr4j-remote](https://github.com/mbari-org/vcr4j/tree/master/vcr4j-remote)
- Python: [sharktopoda-client-py](https://github.com/kevinsbarnard/sharktopoda-client-py)
