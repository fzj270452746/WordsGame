import Foundation

public struct Score: Codable {
    public let score: Int
    public let wordCount: Int
    public let mode: String
    public let date: Date
}

public class ScoreManager {
    private let timeModeSavePath = "time_mode_scores"
    private let challengeModeSavePath = "challenge_mode_scores"
    
    public init() {
        // Default initializer
    }
    
    public func saveScore(_ score: Int, wordCount: Int, forMode mode: GameMode) {
        // 只有当分数大于0时才保存
        guard score > 0 else {
            print("分数为0，不保存到排行榜")
            return
        }
        
        print("保存分数到排行榜：\(score) 分，\(wordCount) 个单词，游戏模式：\(mode == .time ? "限时模式" : "无尽模式")")
        
        let newScore = Score(score: score, wordCount: wordCount, mode: mode == .time ? "time" : "challenge", date: Date())
        var scores = loadScores(forMode: mode)
        scores.append(newScore)
        
        // Sort scores by highest first
        scores.sort { $0.score > $1.score }
        
        // Keep only top 10 scores
        if scores.count > 10 {
            scores = Array(scores.prefix(10))
        }
        
        // Save to UserDefaults
        let data = try? JSONEncoder().encode(scores)
        UserDefaults.standard.set(data, forKey: getSaveKey(forMode: mode))
    }
    
    public func loadScores(forMode mode: GameMode) -> [Score] {
        guard let data = UserDefaults.standard.data(forKey: getSaveKey(forMode: mode)),
              let scores = try? JSONDecoder().decode([Score].self, from: data) else {
            return []
        }
        return scores
    }
    
    private func getSaveKey(forMode mode: GameMode) -> String {
        return mode == .time ? timeModeSavePath : challengeModeSavePath
    }
} 