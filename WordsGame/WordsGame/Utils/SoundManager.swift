import AVFoundation

public enum SoundEffect: String {
    case spin = "spin"
    case success = "success"
    case fail = "fail"
    case click = "click"
    case gameOver = "game_over"
    case letterSelect = "letter_select"
}

public class SoundManager {
    public static let shared = SoundManager()
    
    // Empty initialization - no sound functionality
    private init() {}
    
    // Empty implementation - no sounds will play
    public func play(_ effect: SoundEffect) {
        // Sound effects removed
    }
    
    // Always returns false since sound is disabled
    public func isSoundOn() -> Bool {
        return false
    }
    
    // Empty implementation since sound is disabled
    public func toggleSound(enabled: Bool) {
        // Sound effects disabled
    }
} 