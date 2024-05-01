import AVKit
import SwiftUI

struct PlayerView: View {
    @State private var progress: Float = 0
    @State private var isInteracting: Bool = false
    private let player1 = RawPlayer(playerItem: .init(url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8")!))
    private let player2 = SmoothPlayer(playerItem: .init(url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8")!))

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Text("Raw Seek")
                AVKit.VideoPlayer(player: player1)
            }
            VStack(spacing: 0) {
                Text("Smooth Seek")
                VideoPlayer(player: player2)
            }
            Slider(value: $progress, onEditingChanged: { isInteracting = $0 })
                .padding()
        }
        .foregroundStyle(.white)
        .background(.black)
        .onAppear(perform: run)
        .onChange(of: progress, perform: changed)
        .onChange(of: isInteracting, perform: logs)
    }
}

private extension PlayerView {
    private func run() {
        player1.isMuted = true
        player2.isMuted = true
        player1.play()
        player2.play()
    }

    private func changed(_ value: Float) {
        if let duration = player1.currentItem?.duration {
            let time = CMTime(value: Int64(duration.seconds * Double(value) * 1_000), timescale: 1_000)
            if time.isValid {
                player1.seek(to: time)
            }
        }
        if let duration = player2.currentItem?.duration {
            let time = CMTime(value: Int64(duration.seconds * Double(value) * 1_000), timescale: 1_000)
            if time.isValid {
                player2.seek(to: time)
            }
        }
    }

    private func logs(_ isInteracting: Bool) {
        if !isInteracting {
            print("Raw Player: \(player1.logs.reduce("", +))")
            print("Smooth Player: \(player2.logs.reduce("", +))")
            player1.cleanLogs()
            player2.cleanLogs()
        }
    }
}

#Preview {
    PlayerView()
}
