# IntlJpeg

Swift package for snapshot and video stream HTTP endpoints. Descriptors use [RequestResponse](https://github.com/avgx/RequestResponse); `AccessPoint`, `ObjectID`, and archive timestamps come from [IntlWireFormat](https://github.com/avgx/IntlWireFormat).

For camera topology, see [IntlConfiguration](https://github.com/avgx/IntlConfiguration).

## Project layout

```
Sources/IntlJpeg/
├── API/              SnapshotApi, StreamApi
└── Internal/         VideoActionQuery, headers

Tests/IntlJpegTests/
└── IntlJpegTests.swift
```

## Requirements

- Swift 6.1+
- iOS 15+, macOS 13+, tvOS 17+, visionOS 1+

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/avgx/IntlJpeg", from: "1.0.0"),
],
targets: [
    .target(name: "MyApp", dependencies: ["IntlJpeg"]),
]
```

## Quick start

```swift
import IntlJpeg
import RequestResponse

let jpeg: Data = try await http.send(
    SnapshotApi.live(stream: "CAM:1", height: 480)
).value

let mjpeg: Data = try await http.send(
    StreamApi.mjpegLive(stream: "CAM:1", height: 480, fps: 10)
).value

let rtsp: Data = try await http.send(
    StreamApi.rtspLive(stream: "CAM:1", mic: "MIC:1")
).value
```

## HTTP API descriptors

| Enum | Method | Description |
|------|--------|-------------|
| `SnapshotApi` | `live(stream:height:)` | `GET secure/video/action.do` — `command=frame.video` |
| `SnapshotApi` | `archive(stream:height:time:)` | Archive frame at `time` (`command=arc.frame`; `Timestamp.local`) |
| `StreamApi` | `mjpegLive(stream:height:fps:session:)` | Live MJPEG (`xcommand=live.play`) |
| `StreamApi` | `mjpegArchive(stream:time:height:speed:fps:session:)` | Archive MJPEG; negative `speed` uses reverse play |
| `StreamApi` | `rtspLive(stream:mic:)` | RTSP live — path is camera `ObjectID` via `accessPointObjectId` |
| `StreamApi` | `rtspArchive(stream:time:speed:mic:)` | RTSP archive — `GET archive` with `id`, `time_begin`, optional `z` |

All video actions use `video_in` = `AccessPoint` (e.g. `CAM:1`). RTSP paths use bare `ObjectID` (e.g. `1`), not `CAM:1`.

## Tests

```bash
swift test
```

## License

See [LICENSE](LICENSE).
