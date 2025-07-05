import Foundation
import SwiftData

class TranscriptionService {
    static let shared = TranscriptionService()
    private init() {}

    func transcribeSegments(for session: RecordingSessionModel, context: ModelContext) {
        for segment in session.segments where segment.status == .pending {
            Task {
                await transcribe(segment: segment, session: session, context: context)
            }
        }
    }

    private func transcribe(segment: TranscriptionSegmentModel, session: RecordingSessionModel, context: ModelContext) async {
        guard let fileURL = audioFileURL(for: session.filename) else { return }

        let result = await fakeTranscription(for: fileURL, index: segment.index)

        await MainActor.run {
            switch result {
            case .success(let text):
                segment.text = text
                segment.status = .transcribed
            case .failure:
                segment.retryCount += 1
                if segment.retryCount >= 5 {
                    segment.text = fallbackLocalTranscription()
                    segment.status = .transcribed
                } else {
                    segment.status = .failed
                }
            }
            try? context.save()
        }
    }

    private func fakeTranscription(for fileURL: URL, index: Int) async -> Result<String, Error> {
        try? await Task.sleep(nanoseconds: 500_000_000) // Simulated 0.5s delay
        return .success("Transcribed segment \(index)")
    }

    private func audioFileURL(for filename: String) -> URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(filename)
    }

    private func fallbackLocalTranscription() -> String {
        "Fallback local transcription."
    }
}
