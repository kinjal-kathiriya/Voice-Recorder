import SwiftUI
import UniformTypeIdentifiers

struct ExportButton: View {
    var fileURL: URL

    var body: some View {
        ShareLink(item: fileURL) {
            Label("Export Recording", systemImage: "square.and.arrow.up")
        }
        .accessibilityLabel("Export this recording")
    }
}
