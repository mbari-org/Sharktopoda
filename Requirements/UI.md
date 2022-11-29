# UI

## Overview  

## Start up

When started, Sharktopoda should show a default window like:

![Default](assets/Default.png)

This window should be closed/hidden when any video window is open. When all video windows are closed this window should be displayed. This is the same behavior as the [IINA video player](https://iina.io/).

Both `Open ...` and `Open URL ...` are buttons. When clicked, or the corresponding key strokes occur they should trigger their open action.

`Open ...` brings up a standard file browser.

`Open URL ...` should bring up a dialog that allows a user to enter a movie URL. This is the same behavior as `Open Location` in Apple's QuickTime player.

The `port` number at the bottom displayes the port that Sharktopoda is listening to for incoming UPD commands. It can be changed in _Preferences_.

## Preferences

Sharktopoda will have a standard _Preferences_ menu item:

![Preferences](assets/Prefs.png)

When preferences is opened it will display a window with the tabs/sections shown below. Changes to preferences should be saved when editable field loses focus or the window is closed.

### Annotations (aka Localizations)

Each annotation can be displayed in one of five states:

1. Creation
2. Normal
3. Selected
4. Edited
5. Not displayed

The preferences dialog sets the properties for how each state is drawn.

![Annotation Preferences](assets/Prefs_Annotations.png)

This section specifies how localizations (i.e. annotations) are drawn and represented over video. Most should be obvious but here are additional details on the non-obvious ones:

- __Show annotations check box__: When checked localizations are displayed over top of the video. When unchecked, no localizations are displayed/drawn.
- __Annotation Display > Time Window__: This defines how long a localization should be displayed. The time to display the localization is from `annotation.elapsedTimeMillis - timeWindow / 2.0` to `annotation.elapsedTimeMillis + timeWindow / 2.0`. (e.g. if `elapsedTimeMillis = 1000` and `timeWindow = 30`, the localization for the annotation should be drawn when the video is showing frames between 985 and 1015 milliseconds from the start of the video. This behavior can be modified by the _use duration_ checkbox. (See [Annotation Display](#annotation-display))

#### Annotation Creation

When a new annotation is created this section determines properties of the bounding box as it is being drawn.

#### Annotation Display

This section specifies the properties for an annotation _after_ it has been drawn on the video. By default an annotation is drawn using a the _Default color_ but each annotation may have it's own unique color assigned. Alternatively, all annotations can have a color assigned, when an annotation is created it get's assigned the default color.

When the `use display` check box is selected, annotations are no longer drawn just using the global _Time Window_. Instead, the individual duration for each annotation is applied so the the display time for an annotation becomes `annotation.elapsedTimeMillis` to `annotation.elapsedTimeMillis + annotation.durationMillis`. If the `annotation.durationMillis` value is missing the default value is 0 (zero).

#### Annotation Selection

This specifies the display of _selected_ annotations. Annotations can be selected, either by receiving a command via UDP or by clicking on the localization's border on top of the video.

When only a single annotation is selected. It become [editable](#editing-a-localization). It should be drawn like a selected annotation, but it should also show an indicator that it is editable. Common editing features in other apps are hot corners (little rectangles), circles on the corners, handles on the edges or an opaque fill to indicate the rectangle can be moved or resized. We are flexible in how the editing UI is implemented in Sharktopoda.

### Network

![Network Preferences](assets/Prefs_Network.png)

The _Control Port_ sets the port to listen for incoming [UDP commands](UDP_Remote_Protocol.md). When the port is changed the old port should be closed and Sharktopoda should start listening on the new port.

The _Timeout_ sets the timeout in milliseconds for [outgoing commands](UDP_Remote_Protocol.md#outgoing-commands). This especially important for the [ping](UDP_Remote_Protocol.md#ping) command that is used to check if the Remote App is responsive.

## Behavior

The video window can be a standard AVKit window. Floating playback controls should not be used as they would interact with the interactive localization features. If using AVKit, use [inline](https://developer.apple.com/documentation/avkit/avplayerviewcontrolsstyle/inline) controls.

When a user clicks on the video (not the video controls) it begins a localization action. All localization actions initiate by the video player should immediately pause video playback. Localization actions [initiated by the remote app](UDP_Remote_Protocol.md#incoming-commands) should NOT pause video playback.

### Selecting localizations

If the user clicks anywhere within the bounding box of an existing localization, that single localization should be [selected](UDP_Remote_Protocol.md#select-localizations) and become editable, allowing a user to resize or move the localization.

If the user click is within the bounding box of several overlapping localizations, the selected localization is the one with the closest edge to the click point.

Only a single localization selected using this mouse click action is editable at any time.

Multiple localizations may be selected in either of two ways. A Cmd-Click within the bounding box of an existing localization adds that localization to any previously selected localizations. Alternatively, a user Cmd-Click-Drag will display a temporary bounding box that, upon release of the Cmd-Click-Drag, will select all localizations that intersect the temporary bounding box. The start of the Cmd-Click-Drag action clears any currently selected localizations.

Whenever a selection action completes a [select](UDP_Remote_Protocol.md#select-localizations) command is sent to the remote applications.

### Editing a localization

The region of a localization is editable via a click in the center of a localization's bounding box, followed by a drag action. Upon release of the Click-Drag action, an [update](UDP_Remote_Protocol.md#update_localizations) localization message is sent to the remote control app. If the bounding box of the final position for the localization extends beyond video boundary, the region is clipped to the video boundary and the size is appropriately adjusted.

The size of a localization is editable via a click within the bounding box near a edge, followed by a drag action. There are eight separate click zones, four edges: top, right, bottom, left and four corners: top-right, bottom-right, bottom-left, top-left. Edge zones allow resizing either the width or height perpendicular to the edge. Corner zones resize both the width and height of the region. As with repositioning, an [update](UDP_Remote_Protocol.md#update_localizations) localization message is sent to the remote control app upon release of the Click-Drag action.

The concept field of a localization is not editable via Sharktopoda.

### Creating a localization

If the user performs a Click-Drags action within the video boundary, with the intial click outside of any existing localization, Sharktopoda begins the drawing of a bounding box for a new localization. When the drag is released, an [add](UDP_Remote_Protocol.md#add_localizations) message is sent to the remote control app. The concept and color fields of the new localization are set using the current preferences settings.

Newly created localizations are immediately editable (selected), hence a [select](UDP_Remote_Protocol.md#select_localizations) message is sent to the remote control app.

### Deleting a localization

Localizations may be removed by first selecting one or more localizations, followed by a Cntl-Delete keystroke action.  A [delete](UDP_Remote_Protocol.md#elete_localizatons) message will be immediately be sent to the remote control app.

Note the Cntl-Delete keystroke is used for two reasons. Since deleting localizations is destructive, a definitive two key action is desired. Furthermore, even though other Sharktopoda two key actions tend to use a Cmd-key combination, Cntl-Delete further ensures user intent of the destructive delete by changing the modifier (Cntl vs Cmd) key.
