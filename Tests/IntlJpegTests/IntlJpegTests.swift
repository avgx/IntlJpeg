import Foundation
import Testing
import IntlWireFormat
@testable import IntlJpeg

@Test func snapshotLiveQuery() {
    let request = SnapshotApi.live(stream: "CAM:1", height: 240)
    #expect(request.path == "secure/video/action.do")
    #expect(request.headers?["Accept"] == "image/*")
    #expect(request.query?.contains(where: { $0.0 == "command" && $0.1 == "frame.video" }) == true)
    #expect(request.query?.contains(where: { $0.0 == "video_in" && $0.1 == "CAM:1" }) == true)
}

@Test func snapshotArchiveFormatsTimeFromDate() {
    let time = Date(timeIntervalSince1970: 1_705_318_800)
    let request = SnapshotApi.archive(stream: "CAM:1", height: 480, time: time)
    #expect(request.query?.contains(where: { $0.0 == "command" && $0.1 == "arc.frame" }) == true)
    #expect(request.query?.contains(where: { $0.0 == "time" && $0.1 == Timestamp.local.string(from: time) }) == true)
}

@Test func mjpegArchiveUsesReverseWhenRewinding() {
    let session = UUID(uuidString: "00000000-0000-4000-8000-000000000099")!
    let time = Date(timeIntervalSince1970: 1_705_318_800)
    let request = StreamApi.mjpegArchive(
        stream: "CAM:3",
        time: time,
        speed: -2,
        session: session
    )
    #expect(request.query?.contains(where: { $0.0 == "command" && $0.1 == "arc.play.reverse" }) == true)
    #expect(request.query?.contains(where: { $0.0 == "time_from" && $0.1 == Timestamp.local.string(from: time) }) == true)
    #expect(request.query?.contains(where: { $0.0 == "fps" && $0.1 == "10.0" }) == true)
}

@Test func rtspLiveUsesObjectIDPath() {
    let request = StreamApi.rtspLive(stream: "CAM:7")
    #expect(request.path == "7")
}

@Test func rtspArchiveUsesObjectIDQuery() {
    let time = Date(timeIntervalSince1970: 1_704_000_000)
    let request = StreamApi.rtspArchive(stream: "CAM:5", time: time)
    #expect(request.path == "archive")
    #expect(request.query?.contains(where: { $0.0 == "id" && $0.1 == "5" }) == true)
}
