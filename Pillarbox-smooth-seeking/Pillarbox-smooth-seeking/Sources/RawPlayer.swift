import AVFoundation

class RawPlayer: AVPlayer {
    private(set) var logs: [String] = []

    override func seek(to time: CMTime) {
        seek(to: time) { _ in }
    }

    override func seek(to time: CMTime, completionHandler: @escaping (Bool) -> Void) {
        super.seek(to: time) { [weak self] finished in
            self?.logs.append("\(finished ? "🟢" : "🔴")")
            completionHandler(finished)
        }
    }
}

extension RawPlayer {
    func cleanLogs() {
        logs.removeAll()
    }
}
