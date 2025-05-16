import Foundation

public protocol GameManagerDelegate: AnyObject {
    func gameDidUpdateTime(_ remainingTime: Int)
    func gameDidUpdateScore(_ score: Int)
    func gameDidUpdateWordCount(_ count: Int)
    func gameDidFinish(score: Int)
    func gameDidGenerateNewTiles(_ tiles: [LetterTile])
    func gameDidValidateWord(isValid: Bool, errorMessage: String?, pointsEarned: Int)
}

public class GameManager {
    public weak var delegate: GameManagerDelegate?
    
    private var currentTiles: [LetterTile] = []
    private var score: Int = 0
    private var wordCount: Int = 0      // 跟踪完成的单词数量
    private var consecutiveCorrectWords: Int = 0  // Track consecutive correct words
    private var gameMode: GameMode = .time
    private var timer: Timer?
    private var remainingTime: Int = 0
    
    public init() {
        // No need to load dictionary anymore
    }
    
    public func updateCurrentTiles(_ tiles: [LetterTile]) {
        // Update the currentTiles array with the tiles from the UI
        self.currentTiles = tiles
    }
    
    public func startGame(mode: GameMode) {
        // u9996u5148u786eu4fddu505cu6b62u4efbu4f55u5b58u5728u7684u8ba1u65f6u5668
        timer?.invalidate()
        timer = nil
        
        self.gameMode = mode
        self.score = 0
        self.wordCount = 0              // u91cdu7f6eu5355u8bcdu8ba1u6570
        self.consecutiveCorrectWords = 0  // Reset consecutive counter
        self.currentTiles = []
        
        delegate?.gameDidUpdateScore(score)
        delegate?.gameDidUpdateWordCount(wordCount)
        
        if let timeLimit = mode.timeLimit {
            // Force reset the timer and remaining time
            remainingTime = Int(timeLimit)
            print("Starting game with time limit: \(timeLimit) seconds, mode: \(mode)")
            
            delegate?.gameDidUpdateTime(remainingTime)
            
            // Ensure we're creating a new timer
            if timer != nil {
                timer?.invalidate()
                timer = nil
            }
            
            // Create a new timer on the main thread
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
                RunLoop.current.add(self.timer!, forMode: .common)
            }
        }
        
        // Let the ViewController handle spinning the slot machine
        // spinSlotMachine() - removed this call
    }
    
    public func spinSlotMachine() {
        currentTiles = LetterTile.generateRandomTiles()
        delegate?.gameDidGenerateNewTiles(currentTiles)
    }
    
    public func submitWord(_ word: String) {
        // Check if the word is valid
        let upperCaseWord = word.uppercased()
        
        // Check if all letters are in available tiles
        let wordLetters = Array(upperCaseWord)
        var availableTiles = currentTiles.map { $0.letter }
        
        for letter in wordLetters {
            if let index = availableTiles.firstIndex(of: letter) {
                availableTiles.remove(at: index)
            } else {
                // Reset consecutive counter on failure
                consecutiveCorrectWords = 0
                delegate?.gameDidValidateWord(isValid: false, errorMessage: "You can only use the letters shown", pointsEarned: 0)
                return
            }
        }
        
        // Check if word is in dictionary via API
        WordService.shared.isValidWord(upperCaseWord) { [weak self] isValid, errorMessage in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if isValid {
                    // Word is valid, increment consecutive counter
                    self.consecutiveCorrectWords += 1
                    
                    // 增加单词计数
                    self.wordCount += 1
                    self.delegate?.gameDidUpdateWordCount(self.wordCount)
                    
                    // Calculate bonus points (10 * consecutive count)
                    let pointsEarned = 10 * self.consecutiveCorrectWords
                    
                    // Add to total score
                    self.score += pointsEarned
                    self.delegate?.gameDidUpdateScore(self.score)
                    
                    // Notify delegate of success with points earned
                    self.delegate?.gameDidValidateWord(isValid: true, errorMessage: nil, pointsEarned: pointsEarned)
                } else {
                    // Word is invalid, reset consecutive counter
                    self.consecutiveCorrectWords = 0
                    self.delegate?.gameDidValidateWord(isValid: false, errorMessage: errorMessage, pointsEarned: 0)
                }
            }
        }
    }
    
    public func endGame() {
        // u5728u6e38u620fu7ed3u675fu65f6u5b8cu5168u505cu6b62u8ba1u65f6u5668
        timer?.invalidate()
        timer = nil
        
        // u901au77e5u4ee3u7406u6e38u620fu5df2u7ed3u675f
        delegate?.gameDidFinish(score: score)
    }
    
    @objc private func updateTimer() {
        guard remainingTime > 0 else {
            // u65f6u95f4u5230u4e86uff0cu505cu6b62u8ba1u65f6u5668u5e76u7ed3u675fu6e38u620f
            print("Timer reached zero, ending game")
            timer?.invalidate()
            timer = nil
            delegate?.gameDidFinish(score: score)
            return
        }
        
        remainingTime -= 1
        delegate?.gameDidUpdateTime(remainingTime)
        
        // Print every 10 seconds for debugging
        if remainingTime % 10 == 0 {
            print("Timer update: \(remainingTime) seconds remaining")
        }
    }
} 