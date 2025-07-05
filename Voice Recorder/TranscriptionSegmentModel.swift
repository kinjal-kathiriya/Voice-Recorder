import Foundation
import SwiftData

@Model
class TranscriptionSegmentModel {
    var index: Int
    var text: String
    var status: SegmentStatus
    var recordingSession: RecordingSessionModel?
    var retryCount: Int = 0

    init(index: Int, text: String = "", status: SegmentStatus = .pending, recordingSession: RecordingSessionModel? = nil) {
        self.index = index
        self.text = text
        self.status = status
        self.recordingSession = recordingSession
    }
}

enum SegmentStatus: String, Codable, CaseIterable {
    case pending
    case transcribed
    case failed
}
