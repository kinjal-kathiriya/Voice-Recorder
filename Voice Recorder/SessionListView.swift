import SwiftUI
import SwiftData

struct SessionListView: View {
    @Query(sort: \RecordingSessionModel.createdAt, order: .reverse) var sessions: [RecordingSessionModel]

    var body: some View {
        List {
            ForEach(sessions) { session in
                NavigationLink(destination: SessionDetailView(session: session)) {
                    VStack(alignment: .leading) {
                        Text(session.filename)
                            .font(.headline)
                        Text(session.createdAt, style: .date)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}
