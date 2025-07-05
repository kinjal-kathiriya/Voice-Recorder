import Foundation

class WhisperTranscriptionAPI {
    static let shared = WhisperTranscriptionAPI()
    private init() {}

    func transcribe(audioURL: URL) async throws -> String {
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/audio/transcriptions")!)
        request.httpMethod = "POST"
        request.addValue("Bearer YOUR_API_KEY", forHTTPHeaderField: "Authorization")
        
        // Build multipart form request here (or use your backend)
        throw NSError(domain: "Stub", code: 1, userInfo: [NSLocalizedDescriptionKey: "Transcription logic not yet implemented."])
    }
}
