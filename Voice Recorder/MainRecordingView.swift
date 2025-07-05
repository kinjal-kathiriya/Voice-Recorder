import SwiftUI

struct MainRecordingView: View {
    @StateObject var recorder = AudioEngineRecorder()

    var body: some View {
        VStack(spacing: 16) {
            Text("Audio Transcriber")
                .font(.largeTitle)
                .bold()

            Text(recorder.isRecording ? "Recording..." : "Ready")
                .foregroundColor(.gray)

            WaveformView(level: recorder.audioLevel)
                .frame(height: 80)
                .accessibilityLabel("Live waveform")

            Button(action: {
                recorder.isRecording ? recorder.stopRecording() : recorder.startRecording()
            }) {
                Image(systemName: recorder.isRecording ? "stop.fill" : "mic.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .accessibilityLabel(recorder.isRecording ? "Stop recording" : "Start recording")
            }

            Spacer()
            SessionListView()
        }
        .padding()
    }
}
