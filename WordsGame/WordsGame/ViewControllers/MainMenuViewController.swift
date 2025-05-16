import UIKit

class MainMenuViewController: UIViewController {
    
    // UI Elements
    private let titleLabel = UILabel()
    private let timeButton = RoundedButton(title: "TIME MODE", type: RoundedButton.RoundedButtonStyle.secondary)
    private let challengeButton = RoundedButton(title: "CHALLENGE MODE", type: RoundedButton.RoundedButtonStyle.primary)
    private let leaderboardButton = RoundedButton(title: "LEADERBOARD", type: RoundedButton.RoundedButtonStyle.secondary)
    private let settingsButton = RoundedButton(title: "SETTINGS", type: RoundedButton.RoundedButtonStyle.primary)
    private let titleView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // 只有在返回主菜单时确保背景图片存在
        if isMovingToParent {
            // 确保在每次界面出现时背景图片都被正确加载
            if view.subviews.first(where: { $0 is UIImageView && $0.tag == 999 }) == nil {
                // 如果背景图片不存在，重新添加
                view.addBackgroundImage(named: "bg_main_menu")
                
                // 重新应用渐变（仅当需要重新添加背景图时）
                view.applyGradient(colors: [
                    UIColor(red: 21/255, green: 21/255, blue: 30/255, alpha: 1.0),
                    UIColor(red: 40/255, green: 40/255, blue: 80/255, alpha: 1.0)
                ])
            }
        }
        
        // 设置标题动画
        setupTitle()
        
        // 设置按钮
        setupButtons()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.appBackground
        
        // 首次加载时添加背景图片和设置背景
        view.addBackgroundImage(named: "bg_main_menu")
        setupBackground()
        
        // 设置标题动画
        setupTitle()
        
        // 设置按钮
        setupButtons()
    }
    
    private func setupBackground() {
        // Add background gradient
        view.applyGradient(colors: [
            UIColor(red: 21/255, green: 21/255, blue: 30/255, alpha: 1.0),
            UIColor(red: 40/255, green: 40/255, blue: 80/255, alpha: 1.0)
        ])
        
        // Add slot machine background
        let slotBackground = UIImageView()
        slotBackground.contentMode = .scaleAspectFill
        slotBackground.alpha = 0.3
        slotBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slotBackground)
        
        NSLayoutConstraint.activate([
            slotBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slotBackground.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            slotBackground.widthAnchor.constraint(equalTo: view.widthAnchor),
            slotBackground.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        // Add floating coins/bubbles animation
        addFloatingElements()
    }
    
    private func setupTitle() {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleView)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleView.widthAnchor.constraint(equalToConstant: 300),
            titleView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        // Create monster letter tiles for the title "WORDS"
        let letters = ["W", "O", "R", "D", "S"]
        let tileWidth: CGFloat = 50
        let spacing: CGFloat = 5
        let startX = (300 - (CGFloat(letters.count) * tileWidth + CGFloat(letters.count - 1) * spacing)) / 2
        
        for (index, letter) in letters.enumerated() {
            let letterView = createTitleLetterView(letter: letter)
            titleView.addSubview(letterView)
            
            let xPosition = startX + CGFloat(index) * (tileWidth + spacing)
            letterView.frame = CGRect(x: xPosition, y: 0, width: tileWidth, height: tileWidth)
            
            // Add animation with delay
            UIView.animate(withDuration: 0.5, delay: Double(index) * 0.1, options: [.curveEaseInOut], animations: {
                letterView.frame.origin.y = 20
            }, completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
                    letterView.frame.origin.y = 15
                })
            })
        }
        
        // Add second row "SLOT"
        let secondRowLetters = ["S", "L", "O", "T"]
        let secondRowStartX = (300 - (CGFloat(secondRowLetters.count) * tileWidth + CGFloat(secondRowLetters.count - 1) * spacing)) / 2
        
        for (index, letter) in secondRowLetters.enumerated() {
            let letterView = createTitleLetterView(letter: letter)
            titleView.addSubview(letterView)
            
            let xPosition = secondRowStartX + CGFloat(index) * (tileWidth + spacing)
            letterView.frame = CGRect(x: xPosition, y: 60, width: tileWidth, height: tileWidth)
            
            // Add animation with delay
            UIView.animate(withDuration: 0.5, delay: 0.5 + Double(index) * 0.1, options: [.curveEaseInOut], animations: {
                letterView.frame.origin.y = 70
            }, completion: { _ in
                UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
                    letterView.frame.origin.y = 65
                })
            })
        }
    }
    
    private func createTitleLetterView(letter: String) -> UIView {
        let letterView = UIView()
        letterView.backgroundColor = LetterTile.randomColor()
        letterView.layer.cornerRadius = 10
        
        // Add letter
        let label = UILabel()
        label.text = letter
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 10, width: 50, height: 30)
        letterView.addSubview(label)
        
        // Add eyes
        let leftEye = UIView()
        leftEye.backgroundColor = .white
        leftEye.layer.cornerRadius = 4
        leftEye.frame = CGRect(x: 10, y: 5, width: 8, height: 8)
        
        let rightEye = UIView()
        rightEye.backgroundColor = .white
        rightEye.layer.cornerRadius = 4
        rightEye.frame = CGRect(x: 32, y: 5, width: 8, height: 8)
        
        letterView.addSubview(leftEye)
        letterView.addSubview(rightEye)
        
        // Add pupils
        let leftPupil = UIView()
        leftPupil.backgroundColor = .black
        leftPupil.layer.cornerRadius = 2
        leftPupil.frame = CGRect(x: 12, y: 7, width: 4, height: 4)
        
        let rightPupil = UIView()
        rightPupil.backgroundColor = .black
        rightPupil.layer.cornerRadius = 2
        rightPupil.frame = CGRect(x: 34, y: 7, width: 4, height: 4)
        
        letterView.addSubview(leftPupil)
        letterView.addSubview(rightPupil)
        
        return letterView
    }
    
    private func setupButtons() {
        let buttonStackView = UIStackView()
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 20
        buttonStackView.alignment = .center
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStackView)
        
        // Configure buttons
        [timeButton, challengeButton, leaderboardButton, settingsButton].forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 60).isActive = true
            button.widthAnchor.constraint(equalToConstant: 280).isActive = true
            buttonStackView.addArrangedSubview(button)
        }
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 60),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.widthAnchor.constraint(equalToConstant: 280)
        ])
        
        // Add actions
        timeButton.addTarget(self, action: #selector(startTimeMode), for: .touchUpInside)
        challengeButton.addTarget(self, action: #selector(startChallengeMode), for: .touchUpInside)
        leaderboardButton.addTarget(self, action: #selector(openLeaderboard), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
    }
    
    private func addFloatingElements() {
        // Add floating coins/bubbles
        let numberOfElements = 12
        
        for _ in 0..<numberOfElements {
            addFloatingBubble()
        }
    }
    
    private func addFloatingBubble() {
        let bubble = UIView()
        let size = CGFloat.random(in: 20...60)
        bubble.backgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        bubble.layer.cornerRadius = size / 2
        
        // Random starting position
        let startX = CGFloat.random(in: -20...(view.bounds.width + 20))
        let startY = view.bounds.height + size
        
        bubble.frame = CGRect(x: startX, y: startY, width: size, height: size)
        view.insertSubview(bubble, at: 0) // Add at the back
        
        // Animate the bubble floating up
        let duration = TimeInterval.random(in: 10...15)
        let endY = -size
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear], animations: {
            bubble.frame.origin.y = endY
        }) { _ in
            bubble.removeFromSuperview()
            self.addFloatingBubble() // Add a new bubble when this one finishes
        }
    }
    
    // MARK: - Button Actions
    
    @objc private func startTimeMode() {
        SoundManager.shared.play(.click)
        let gameVC = GameViewController()
        gameVC.startGame(mode: .time)
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
    @objc private func startChallengeMode() {
        SoundManager.shared.play(.click)
        let gameVC = GameViewController()
        gameVC.startGame(mode: .challenge)
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
    @objc private func openLeaderboard() {
        SoundManager.shared.play(.click)
        let leaderboardVC = LeaderboardViewController()
        navigationController?.pushViewController(leaderboardVC, animated: true)
    }
    
    @objc private func openSettings() {
        let aboutVC = AboutViewController()
        navigationController?.pushViewController(aboutVC, animated: true)
    }
} 