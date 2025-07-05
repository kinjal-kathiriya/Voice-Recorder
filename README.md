# 🎙️ Voice Recorder & Transcriber (iOS)

A robust iOS app built with **SwiftUI**, **AVAudioEngine**, **SwiftData**, and **OpenAI Whisper**, enabling seamless background audio recording and intelligent transcription — even in real-world conditions like interruptions and audio route changes.

---

## 🚀 Features

- 🎤 **Background audio recording** with `AVAudioEngine`
- ⏱️ **Automatic 30-second segmentation** of recordings
- 🤖 **Whisper API integration** for accurate speech-to-text
- 🔁 **Retry logic** and **fallback** to Apple Speech API
- 📁 **SwiftData** model for recording sessions & segments
- 📊 **Live waveform visualization**
- 🧠 **Searchable recording history**
- 📤 **Export support** (via `ShareLink`)
- 🦾 **VoiceOver and accessibility** support
- 🔐 **Keychain-secured API token management**
- 📉 **Battery and memory efficient** design

---

## 📦 Project Structure

| File / Folder                | Purpose                               |
|-----------------------------|----------------------------------------|
| `AudioEngineRecorder.swift` | Handles AVAudioEngine setup & waveform |
| `TranscriptionService.swift`| Sends audio to Whisper + fallback      |
| `RecordingSession.swift`    | Struct model for sessions              |
| `TranscriptionSegmentModel.swift` | SwiftData model for segments     |
| `SessionListView.swift`     | Lists past recordings via SwiftData    |
| `MainRecordingView.swift`   | Recording UI with waveform + button    |
| `WaveformView.swift`        | Displays real-time audio level         |
| `ExportButton.swift`        | Enables sharing a session's file       |

