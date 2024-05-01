import AVFoundation

class SmoothPlayer: AVPlayer {
    private var isSeeking = false
    private var seekTimes: [CMTime] = []
    private(set) var logs: [String] = []

    override func seek(to time: CMTime) {
        seek(to: time) { _ in }
    }

    override func seek(to time: CMTime, completionHandler: @escaping (Bool) -> Void) {
        seekTimes.append(time)
        if !isSeeking, let firstSeekTime = seekTimes.first {
            isSeeking = true
            super.seek(to: firstSeekTime, completionHandler: seekCompletion)
        }
    }

    private func seekCompletion(_ finished: Bool) {
        logs.append("\(finished ? "🟢" : "🔴")")
        if let lastSeekTime = seekTimes.last {
            seekTimes = [lastSeekTime]
            super.seek(to: lastSeekTime) { [weak self] finished in
                self?.seekTimes.removeFirst()
                self?.seekCompletion(finished)
            }
        } else {
            self.isSeeking = false
        }
    }
}

extension SmoothPlayer {
    func cleanLogs() {
        logs.removeAll()
    }
}
