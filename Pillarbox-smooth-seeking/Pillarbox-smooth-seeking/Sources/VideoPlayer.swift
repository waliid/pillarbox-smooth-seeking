import AVFoundation
import SwiftUI
import UIKit

struct VideoPlayer: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> UIView {
        PlayerLayerView(player: player)
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

private class PlayerLayerView: UIView {
    let player: AVPlayer
    let playerLayer: AVPlayerLayer

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(player: AVPlayer) {
        self.player = player
        self.playerLayer = AVPlayerLayer(player: player)
        super.init(frame: .zero)
        layer.addSublayer(playerLayer)
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        playerLayer.frame = layer.bounds
    }
}

