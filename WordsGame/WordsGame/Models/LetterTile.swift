import UIKit

public struct LetterTile {
    public let letter: Character
    public let color: UIColor
    public var isSelected: Bool = false
    
    public static let colors: [UIColor] = [
        UIColor(red: 255/255, green: 87/255, blue: 140/255, alpha: 1),  // Pink
        UIColor(red: 87/255, green: 201/255, blue: 255/255, alpha: 1),  // Blue
        UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1),  // Green
        UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1),   // Orange
        UIColor(red: 175/255, green: 82/255, blue: 222/255, alpha: 1),  // Purple
        UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)    // Yellow
    ]
    
    public static func randomColor() -> UIColor {
        return colors[Int.random(in: 0..<colors.count)]
    }
    
    public static func generateRandomTiles(count: Int = 5) -> [LetterTile] {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var tiles: [LetterTile] = []
        
        for _ in 0..<count {
            if let randomLetter = letters.randomElement() {
                tiles.append(LetterTile(letter: randomLetter, color: randomColor()))
            }
        }
        
        return tiles
    }
} 