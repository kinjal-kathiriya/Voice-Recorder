import Foundation
import SwiftData

@MainActor
class RecordingViewModel: ObservableObject {
    var modelContext: ModelContext

    @Published var currentSession: RecordingSession?
    @Published var segmentModels: [TranscriptionSegmentModel] = []

    init(context: ModelContext) {
        self.modelContext = context
    }

    func startNewSession() {
        let session = RecordingSession(
            name: "Recording \(Date().formatted(date: .abbreviated, time: .shortened))",
            date: Date(),
            duration: 0
        )
        currentSession = session
        // Optionally save if needed
    }

    func addSegment(index: Int, text: String = "", status: SegmentStatus = .transcribed) {
        let segment = TranscriptionSegmentModel(
            index: index,
            text: text,
            status: status,
            recordingSession: nil // associate with sessionModel if needed
        )
        modelContext.insert(segment)
        segmentModels.append(segment)
        try? modelContext.save()
    }

    func saveSession() {
        if let session = currentSession {
            // You may want to persist it with SwiftData if it's not already
            // Currently RecordingSession is a struct, not @Model
        }
    }
}
