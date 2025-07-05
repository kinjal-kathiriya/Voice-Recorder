import AVFoundation
import Combine
import Accelerate

class AudioEngineRecorder: ObservableObject {
    private let engine = AVAudioEngine()
    private var audioFile: AVAudioFile?
    @Published var isRecording = false
    @Published var errorMessage: String?
    @Published var audioLevel: Float = -160.0  // For waveform

    private(set) var currentFilename: String = ""
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupNotifications()
    }

    func startRecording(to filename: String = UUID().uuidString + ".m4a") {
        currentFilename = filename
        let session = AVAudioSession.sharedInstance()

        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true)
        } catch {
            errorMessage = "Failed to set audio session: \(error.localizedDescription)"
            return
        }

        let format = engine.inputNode.outputFormat(forBus: 0)

        do {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
            audioFile = try AVAudioFile(forWriting: url, settings: format.settings)
        } catch {
            errorMessage = "Failed to create file: \(error.localizedDescription)"
            return
        }

        engine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            self.updateAudioLevel(from: buffer)
            do {
                try self.audioFile?.write(from: buffer)
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Recording failed: \(error.localizedDescription)"
                }
            }
        }

        do {
            engine.prepare()
            try engine.start()
            isRecording = true
        } catch {
            errorMessage = "Failed to start engine: \(error.localizedDescription)"
        }
    }

    func stopRecording() {
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        isRecording = false
    }

    private func setupNotifications() {
        NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)
            .sink { self.handleInterruption(notification: $0) }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: AVAudioSession.routeChangeNotification)
            .sink { self.handleRouteChange(notification: $0) }
            .store(in: &cancellables)
    }

    private func handleInterruption(notification: Notification) {
        guard let typeValue = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }

        switch type {
        case .began:
            stopRecording()
        case .ended:
            if let optionsValue = notification.userInfo?[AVAudioSessionInterruptionOptionKey] as? UInt,
               AVAudioSession.InterruptionOptions(rawValue: optionsValue).contains(.shouldResume) {
                startRecording()
            }
        @unknown default:
            break
        }
    }

    private func handleRouteChange(notification: Notification) {
        // Optional: Handle route changes here
    }

    private func updateAudioLevel(from buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let frameLength = Int(buffer.frameLength)

        var rms: Float = 0
        vDSP_meamgv(channelData, 1, &rms, vDSP_Length(frameLength))
        let avgPower = 20 * log10(rms)
        DispatchQueue.main.async {
            self.audioLevel = avgPower
        }
    }
}
