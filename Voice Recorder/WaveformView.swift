import SwiftUI

struct WaveformView: View {
    var level: Float

    var body: some View {
        GeometryReader { geometry in
            let height = CGFloat(max(0.05, CGFloat(level + 160) / 160)) * geometry.size.height
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.green)
                .frame(width: geometry.size.width, height: height)
                .offset(y: geometry.size.height - height)
        }
        .animation(.linear(duration: 0.05), value: level)
    }
}
