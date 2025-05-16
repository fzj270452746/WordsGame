import Foundation

public enum GameMode {
    case time
    case challenge
    
    public var title: String {
        switch self {
        case .time:
            return "TIME MODE"
        case .challenge:
            return "CHALLENGE MODE"
        }
    }
    
    public var description: String {
        switch self {
        case .time:
            return "Complete as many words as possible in 2 minutes."
        case .challenge:
            return "No time limit, keep playing to achieve your best score."
        }
    }
    
    public var timeLimit: TimeInterval? {
        switch self {
        case .time:
            return 120 // 2 minutes
        case .challenge:
            return nil
        }
    }
} 