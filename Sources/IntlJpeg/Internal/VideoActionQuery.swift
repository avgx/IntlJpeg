import Foundation
import IntlWireFormat

enum VideoAction {
    static let path = "secure/video/action.do"
    static let version = "4.10.0.0"
}

enum VideoHeaders {
    static let acceptImage = ["Accept": "image/*"]
    static let acceptAll = ["Accept": "*/*"]
}

func requireAccessPoint(_ stream: AccessPoint) {
    precondition(stream.components != nil, "stream must be Class:Id access point")
}

func requireCameraObjectID(_ stream: AccessPoint) -> ObjectID {
    requireAccessPoint(stream)
    guard let objectID = stream.accessPointObjectId else {
        preconditionFailure("stream must include object id")
    }
    return objectID
}

func videoQuery(
    _ pairs: [(String, String?)]
) -> [(String, String?)] {
    var query = pairs
    if !query.contains(where: { $0.0 == "version" }) {
        query.append(("version", VideoAction.version))
    }
    if !query.contains(where: { $0.0 == "sessionid" }) {
        query.append(("sessionid", UUID().uuidString))
    }
    return query
}

extension Date {
    func archiveRtspString() -> String {
        Timestamp.archiveUTC.string(from: self)
    }
}
