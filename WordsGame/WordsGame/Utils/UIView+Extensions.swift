import UIKit

public extension UIView {
    func addShadow(opacity: Float = 0.3, radius: CGFloat = 3, offset: CGSize = CGSize(width: 0, height: 2)) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.masksToBounds = false
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -15.0, 15.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        layer.add(animation, forKey: "shake")
    }
    
    func pulse() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.3
        pulse.fromValue = 1.0
        pulse.toValue = 1.1
        pulse.autoreverses = true
        pulse.initialVelocity = 0.5
        pulse.damping = 0.8
        layer.add(pulse, forKey: "pulse")
    }
    
    func bounce() {
        let bounce = CASpringAnimation(keyPath: "transform.scale")
        bounce.duration = 0.5
        bounce.fromValue = 0.7
        bounce.toValue = 1.0
        bounce.autoreverses = false
        bounce.initialVelocity = 0.5
        bounce.damping = 0.8
        layer.add(bounce, forKey: "bounce")
    }
    
    func applyGradient(colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 0, y: 1)) {
        // Remove any existing gradient layers
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addBackgroundImage(named imageName: String) {
        // 首先移除任何已存在的背景图片视图和覆盖层，避免堆积
        subviews.forEach { view in
            if let imageView = view as? UIImageView, imageView.tag == 999 {
                imageView.removeFromSuperview()
            }
            if let overlayView = view as? UIView, overlayView.tag == 998 {
                overlayView.removeFromSuperview()
            }
        }
        
        // 检查图片是否已经加载到内存中
        guard let image = UIImage(named: imageName) else {
            print("Warning: Failed to load image named \(imageName)")
            return
        }
        
        // 优化图片加载 - 使用更高效的方式创建和配置图片视图
        let backgroundImageView = UIImageView(image: image)
        backgroundImageView.tag = 999 // 使用tag标记背景图片视图
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true // 避免图片超出视图边界
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // 插入到视图层次的最底层
        self.insertSubview(backgroundImageView, at: 0)
        
        // 设置约束
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        // 添加半透明覆盖层以确保文本可读性
        let overlayView = UIView()
        overlayView.tag = 998 // 使用tag标记覆盖层视图
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(overlayView, at: 1)
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: self.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    // 添加一个新方法用于清理背景资源
    func clearBackgroundImage() {
        subviews.forEach { view in
            if let imageView = view as? UIImageView, imageView.tag == 999 {
                imageView.removeFromSuperview()
            }
            if let overlayView = view as? UIView, overlayView.tag == 998 {
                overlayView.removeFromSuperview()
            }
        }
    }
}

public extension UIColor {
    static let appBackground = UIColor(red: 21/255, green: 21/255, blue: 30/255, alpha: 1.0)
    static let cardBackground = UIColor(red: 42/255, green: 42/255, blue: 58/255, alpha: 0.7)
}

public extension UITextField {
    func applyGameStyle() {
        backgroundColor = UIColor.white.withAlphaComponent(0.2)
        textColor = .white
        font = UIFont.systemFont(ofSize: 18, weight: .medium)
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)]
        )
        
        // Add padding
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: frame.height))
        leftViewMode = .always
        self.leftView = leftView
    }
} 