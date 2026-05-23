import Foundation
import IntlWireFormat
import RequestResponse

public enum SnapshotApi {
    public static func live(stream: AccessPoint, height: Int) -> Request<Data> {
        requireAccessPoint(stream)
        let query = videoQuery([
            ("command", "frame.video"),
            ("video_in", stream),
            ("height", String(height)),
            ("imageHeight", String(height)),
            ("normalize", "true"),
        ])
        return Request(
            path: VideoAction.path,
            method: .get,
            query: query,
            headers: VideoHeaders.acceptImage
        )
    }

    public static func archive(stream: AccessPoint, height: Int, time: Date) -> Request<Data> {
        requireAccessPoint(stream)
        let timeString = Timestamp.local.string(from: time)
        let query = videoQuery([
            ("command", "arc.frame"),
            ("video_in", stream),
            ("height", String(height)),
            ("imageHeight", String(height)),
            ("time", timeString),
            ("range", "0.1"),
            ("normalize", "true"),
        ])
        return Request(
            path: VideoAction.path,
            method: .get,
            query: query,
            headers: VideoHeaders.acceptImage
        )
    }
}
