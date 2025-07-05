import Foundation
import SwiftData

@Model
class RecordingSessionModel {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var duration: Int
    var filename: String
    var segments: [TranscriptionSegmentModel] = []

    init(createdAt: Date = .now, duration: Int, filename: String) {
        self.id = UUID()
        self.createdAt = createdAt
        self.duration = duration
        self.filename = filename
    }
}
