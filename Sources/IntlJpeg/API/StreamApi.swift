import Foundation
import IntlWireFormat
import RequestResponse

public enum StreamApi {
    public static func mjpegLive(
        stream: AccessPoint,
        height: Int = 480,
        fps: Int = 10,
        session: UUID = UUID()
    ) -> Request<Data> {
        requireAccessPoint(stream)
        let query = videoQuery([
            ("xcommand", "live.play"),
            ("video_in", stream),
            ("height", String(height)),
            ("imageHeight", String(height)),
            ("fps", "\(fps).0"),
            ("normalize", "true"),
            ("sessionid", session.uuidString),
        ])
        return Request(
            path: VideoAction.path,
            method: .get,
            query: query,
            headers: VideoHeaders.acceptAll
        )
    }

    public static func mjpegArchive(
        stream: AccessPoint,
        time: Date,
        height: Int = 480,
        speed: Double = 1.0,
        fps: Int = 10,
        session: UUID = UUID()
    ) -> Request<Data> {
        requireAccessPoint(stream)
        let query = videoQuery([
            ("command", speed > 0 ? "arc.play" : "arc.play.reverse"),
            ("video_in", stream),
            ("time_from", Timestamp.local.string(from: time)),
            ("height", String(height)),
            ("imageHeight", String(height)),
            ("fps", "\(fps).0"),
            ("speed_factor", String(abs(speed))),
            ("normalize", "true"),
            ("sessionid", session.uuidString),
        ])
        return Request(
            path: VideoAction.path,
            method: .get,
            query: query,
            headers: VideoHeaders.acceptAll
        )
    }

    public static func rtspLive(stream: AccessPoint, mic: AccessPoint? = nil) -> Request<Data> {
        let objectID = requireCameraObjectID(stream)
        var query: [(String, String?)] = []
        if let mic, let micID = mic.accessPointObjectId {
            query.append(("mic_id", micID))
        }
        return Request(path: objectID, method: .get, query: query)
    }

    public static func rtspArchive(
        stream: AccessPoint,
        time: Date,
        speed: Double = 1.0,
        mic: AccessPoint? = nil
    ) -> Request<Data> {
        let objectID = requireCameraObjectID(stream)

        let timeFormatted = time.archiveRtspString()
        let timePast = time.addingTimeInterval(-3600).archiveRtspString()
        let timeNow = Date().archiveRtspString()
        let timeBegin = speed > 0 ? timeFormatted : timePast
        let timeEnd = speed > 0 ? timeNow : timeFormatted

        var query: [(String, String?)] = [
            ("id", objectID),
            ("time_begin", timeBegin),
        ]

        if let mic, let micID = mic.accessPointObjectId {
            query.append(("mic_id", micID))
        }
        if Int(speed) != 1 {
            if speed < 0 {
                query.append(("time_end", timeEnd))
            }
            query.append(("z", String(speed)))
        }

        return Request(path: "archive", method: .get, query: query)
    }
}
