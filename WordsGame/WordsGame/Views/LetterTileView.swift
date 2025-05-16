import UIKit

public class LetterTileView: UIView {
    
    private var tile: LetterTile
    private let letterLabel = UILabel()
    
    public var onTap: ((LetterTileView) -> Void)?
    
    public var isSelected: Bool = false {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    public var isUsed: Bool = false {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    public init(tile: LetterTile, frame: CGRect = .zero) {
        self.tile = tile
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // View configuration
        backgroundColor = tile.color
        layer.cornerRadius = 12
        clipsToBounds = true
        
        // Add shadow and border
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4
        
        // Setup letter label
        letterLabel.text = String(tile.letter)
        letterLabel.textColor = .white
        letterLabel.font = UIFont.boldSystemFont(ofSize: 32)
        letterLabel.textAlignment = .center
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(letterLabel)
        
        // Add monster face elements (eyes, mouth)
        addMonsterFaceElements()
        
        // Center the label
        NSLayoutConstraint.activate([
            letterLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            letterLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    private func addMonsterFaceElements() {
        // Create eyes container
        let eyesContainer = UIView()
        eyesContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(eyesContainer)
        
        // Position eyes container
        NSLayoutConstraint.activate([
            eyesContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            eyesContainer.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            eyesContainer.widthAnchor.constraint(equalToConstant: 40),
            eyesContainer.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        // Left eye
        let leftEye = createEye()
        eyesContainer.addSubview(leftEye)
        leftEye.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        
        // Right eye
        let rightEye = createEye()
        eyesContainer.addSubview(rightEye)
        rightEye.frame = CGRect(x: 25, y: 0, width: 15, height: 15)
        
        // Add mouth
        let mouth = createMouth()
        addSubview(mouth)
        mouth.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mouth.centerXAnchor.constraint(equalTo: centerXAnchor),
            mouth.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            mouth.widthAnchor.constraint(equalToConstant: 30),
            mouth.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        // Add decorations like antennas
        addRandomDecorations()
    }
    
    private func createEye() -> UIView {
        let eye = UIView()
        eye.backgroundColor = .white
        eye.layer.cornerRadius = 7.5
        
        let pupil = UIView()
        pupil.backgroundColor = .black
        pupil.layer.cornerRadius = 3
        pupil.frame = CGRect(x: 5, y: 5, width: 6, height: 6)
        
        eye.addSubview(pupil)
        return eye
    }
    
    private func createMouth() -> UIView {
        let mouth = UIView()
        mouth.backgroundColor = .white
        mouth.layer.cornerRadius = 7.5
        
        // Create teeth
        let leftTooth = UIView()
        leftTooth.backgroundColor = .white
        leftTooth.layer.cornerRadius = 2
        leftTooth.frame = CGRect(x: 5, y: 0, width: 4, height: 8)
        
        let rightTooth = UIView()
        rightTooth.backgroundColor = .white
        rightTooth.layer.cornerRadius = 2
        rightTooth.frame = CGRect(x: 20, y: 0, width: 4, height: 8)
        
        mouth.addSubview(leftTooth)
        mouth.addSubview(rightTooth)
        return mouth
    }
    
    private func addRandomDecorations() {
        let shouldAddAntennas = arc4random_uniform(2) == 0
        
        if shouldAddAntennas {
            // Add antennas
            let leftAntenna = createAntenna()
            addSubview(leftAntenna)
            leftAntenna.translatesAutoresizingMaskIntoConstraints = false
            
            let rightAntenna = createAntenna()
            addSubview(rightAntenna)
            rightAntenna.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                leftAntenna.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -15),
                leftAntenna.bottomAnchor.constraint(equalTo: topAnchor, constant: 5),
                leftAntenna.widthAnchor.constraint(equalToConstant: 3),
                leftAntenna.heightAnchor.constraint(equalToConstant: 10),
                
                rightAntenna.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 15),
                rightAntenna.bottomAnchor.constraint(equalTo: topAnchor, constant: 5),
                rightAntenna.widthAnchor.constraint(equalToConstant: 3),
                rightAntenna.heightAnchor.constraint(equalToConstant: 10)
            ])
        }
    }
    
    private func createAntenna() -> UIView {
        let antenna = UIView()
        antenna.backgroundColor = .white
        
        let dot = UIView()
        dot.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0.7, alpha: 1.0)
        dot.layer.cornerRadius = 3
        dot.frame = CGRect(x: -1.5, y: -6, width: 6, height: 6)
        
        antenna.addSubview(dot)
        return antenna
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if isUsed {
            // Used tiles appearance
            layer.borderWidth = 0
            transform = .identity
            alpha = 0.5
            letterLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        } else if isSelected {
            // Selected tiles appearance
            layer.borderWidth = 3
            layer.borderColor = UIColor.white.cgColor
            transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            alpha = 1.0
            letterLabel.textColor = .white
        } else {
            // Normal tiles appearance
            layer.borderWidth = 0
            transform = .identity
            alpha = 1.0
            letterLabel.textColor = .white
        }
    }
    
    @objc private func handleTap() {
        // Don't allow selection of used tiles
        if isUsed {
            return
        }
        
        isSelected = !isSelected
        
        DispatchQueue.main.async {
            self.onTap?(self)
        }
    }
    
    public func update(with tile: LetterTile) {
        self.tile = tile
        letterLabel.text = String(tile.letter)
        backgroundColor = tile.color
        isSelected = tile.isSelected
    }
    
    public var letter: Character {
        return tile.letter
    }
} 