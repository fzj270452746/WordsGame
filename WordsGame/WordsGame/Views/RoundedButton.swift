import UIKit

public class RoundedButton: UIButton {
    
    public enum RoundedButtonStyle {
        case primary
        case secondary
        case danger
    }
    
    public var customButtonType: RoundedButtonStyle = .primary
    
    public init(title: String, type: RoundedButtonStyle = .primary, frame: CGRect = .zero) {
        super.init(frame: frame)
        self.customButtonType = type
        setupButton(with: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton(with: "Button")
    }
    
    private func setupButton(with title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        layer.cornerRadius = 25
        clipsToBounds = true
        
        // Add shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4
        
        // Set colors based on button type
        updateColors()
        
        // Add touch down effect
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    private func updateColors() {
        switch customButtonType {
        case .primary:
            backgroundColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
            setTitleColor(.white, for: .normal)
        case .secondary:
            backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
            setTitleColor(.white, for: .normal)
        case .danger:
            backgroundColor = UIColor(red: 255/255, green: 59/255, blue: 97/255, alpha: 1)
            setTitleColor(.white, for: .normal)
        }
    }
    
    @objc private func touchDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            self.alpha = 0.9
        }
    }
    
    @objc private func touchUp() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
    
    public func setButtonStyle(_ style: RoundedButtonStyle) {
        self.customButtonType = style
        updateColors()
    }
} 
