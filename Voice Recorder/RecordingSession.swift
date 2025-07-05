import Foundation

struct RecordingSession: Identifiable {
    let id = UUID()
    let name: String
    let date: Date
    let duration: Int // in seconds
}
