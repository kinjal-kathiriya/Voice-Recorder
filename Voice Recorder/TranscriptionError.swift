import Foundation

enum TranscriptionError: Error {
    case invalidResponse
    case apiError(String)
    case networkError(Error)
    case fileNotFound
}

class WhisperTranscriptionService {
    static let shared = WhisperTranscriptionService()
    private init() {}

    private let apiKey: String = {
        // Ideally fetched from Keychain
        return "YOUR_OPENAI_API_KEY"
    }()

    func transcribe(audioFileURL: URL) async throws -> String {
        guard FileManager.default.fileExists(atPath: audioFileURL.path) else {
            throw TranscriptionError.fileNotFound
        }

        let boundary = UUID().uuidString
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/audio/transcriptions")!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let audioData = try Data(contentsOf: audioFileURL)
        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"audio.m4a\"\r\n")
        body.append("Content-Type: audio/m4a\r\n\r\n")
        body.append(audioData)
        body.append("\r\n")

        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n")
        body.append("whisper-1\r\n")
        body.append("--\(boundary)--\r\n")

        request.httpBody = body

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw TranscriptionError.invalidResponse
            }

            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let text = json["text"] as? String {
                return text
            } else {
                throw TranscriptionError.invalidResponse
            }
        } catch {
            throw TranscriptionError.networkError(error)
        }
    }
}
