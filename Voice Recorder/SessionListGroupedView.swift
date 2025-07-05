import SwiftUI
import SwiftData

struct SessionListGroupedView: View {
    @Query(sort: \RecordingSessionModel.createdAt, order: .reverse) var sessions: [RecordingSessionModel]
    @State private var searchText = ""

    var groupedSessions: [String: [RecordingSessionModel]] {
        Dictionary(grouping: filteredSessions) {
            DateFormatter.localizedString(from: $0.createdAt, dateStyle: .medium, timeStyle: .none)
        }
    }

    var filteredSessions: [RecordingSessionModel] {
        if searchText.isEmpty {
            return sessions
        } else {
            return sessions.filter { $0.filename.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        List {
            ForEach(groupedSessions.keys.sorted(by: >), id: \.self) { dateKey in
                Section(header: Text(dateKey)) {
                    ForEach(groupedSessions[dateKey] ?? []) { session in
                        NavigationLink(destination: SessionDetailView(session: session)) {
                            VStack(alignment: .leading) {
                                Text(session.filename)
                                Text(session.createdAt, style: .time)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .refreshable {
            // You can refetch or reload here if needed
        }
        .navigationTitle("Sessions")
    }
}
