import SwiftUI

struct SessionDetailView: View {
    let session: RecordingSessionModel

    var body: some View {
        List {
            ForEach(session.segments.sorted(by: { $0.index < $1.index })) { segment in
                VStack(alignment: .leading, spacing: 4) {
                    Text("Segment \(segment.index)")
                        .font(.headline)

                    if segment.text.isEmpty {
                        Label("Pending...", systemImage: "clock")
                            .foregroundColor(.gray)
                    } else {
                        Text(segment.text)
                            .font(.body)
                    }

                    Text("Status: \(segment.status.rawValue.capitalized)")
                        .font(.caption)
                        .foregroundColor(segment.status == .failed ? .red : .green)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Session Detail")
    }
}
