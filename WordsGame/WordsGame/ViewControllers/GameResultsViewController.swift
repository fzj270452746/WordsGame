import UIKit

class GameResultsViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let scoreLabel = UILabel()
    private let scoreValueLabel = UILabel()
    private let wordCountLabel = UILabel()
    private let wordCountValueLabel = UILabel()
    private let messageLabel = UILabel()
    private let playAgainButton = RoundedButton(title: "PLAY AGAIN", type: RoundedButton.RoundedButtonStyle.primary)
    private let mainMenuButton = RoundedButton(title: "MAIN MENU", type: RoundedButton.RoundedButtonStyle.secondary)
    private let scoreContainer = UIView()
    
    private let score: Int
    private let wordCount: Int
    private let gameMode: GameMode
    private let scoreManager = ScoreManager()
    
    init(score: Int, wordCount: Int, mode: GameMode) {
        self.score = score
        self.wordCount = wordCount
        self.gameMode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // 不再需要在此处保存分数，因为在GameViewController的endGame中已经保存
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 当视图即将消失时清理背景资源
        view.clearBackgroundImage()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.appBackground
        
        // 添加背景图片
        view.addBackgroundImage(named: "bg_results")
        
        // 应用渐变背景（应用在背景图片之上）
        view.applyGradient(colors: [
            UIColor(red: 21/255, green: 21/255, blue: 30/255, alpha: 1.0),
            UIColor(red: 40/255, green: 40/255, blue: 80/255, alpha: 1.0)
        ])
        
        // 添加五彩纸屑动画
        addConfetti()
        
        // 标题标签
        titleLabel.text = "GAME OVER"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Score container
        scoreContainer.backgroundColor = UIColor.cardBackground
        scoreContainer.layer.cornerRadius = 20
        scoreContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreContainer)
        
        // Score label
        scoreLabel.text = "YOUR SCORE"
        scoreLabel.textColor = .white
        scoreLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        scoreLabel.textAlignment = .center
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreContainer.addSubview(scoreLabel)
        
        // Score value
        scoreValueLabel.text = "\(score) POINTS"
        scoreValueLabel.textColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
        scoreValueLabel.font = UIFont.boldSystemFont(ofSize: 36)
        scoreValueLabel.textAlignment = .center
        scoreValueLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreContainer.addSubview(scoreValueLabel)
        
        // Word count label
        wordCountLabel.text = "WORDS COMPLETED"
        wordCountLabel.textColor = .white
        wordCountLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        wordCountLabel.textAlignment = .center
        wordCountLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreContainer.addSubview(wordCountLabel)
        
        // Word count value
        wordCountValueLabel.text = "\(wordCount)"
        wordCountValueLabel.textColor = UIColor(red: 87/255, green: 201/255, blue: 255/255, alpha: 1.0)
        wordCountValueLabel.font = UIFont.boldSystemFont(ofSize: 36)
        wordCountValueLabel.textAlignment = .center
        wordCountValueLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreContainer.addSubview(wordCountValueLabel)
        
        // Message label
        messageLabel.text = getMessageForScore(score)
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 18)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageLabel)
        
        // Buttons
        playAgainButton.translatesAutoresizingMaskIntoConstraints = false
        playAgainButton.addTarget(self, action: #selector(playAgainButtonTapped), for: .touchUpInside)
        view.addSubview(playAgainButton)
        
        mainMenuButton.translatesAutoresizingMaskIntoConstraints = false
        mainMenuButton.addTarget(self, action: #selector(mainMenuButtonTapped), for: .touchUpInside)
        view.addSubview(mainMenuButton)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scoreContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            scoreContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            scoreContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            scoreContainer.heightAnchor.constraint(equalToConstant: 240),
            
            scoreLabel.topAnchor.constraint(equalTo: scoreContainer.topAnchor, constant: 30),
            scoreLabel.centerXAnchor.constraint(equalTo: scoreContainer.centerXAnchor),
            
            scoreValueLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10),
            scoreValueLabel.centerXAnchor.constraint(equalTo: scoreContainer.centerXAnchor),
            
            wordCountLabel.topAnchor.constraint(equalTo: scoreValueLabel.bottomAnchor, constant: 30),
            wordCountLabel.centerXAnchor.constraint(equalTo: scoreContainer.centerXAnchor),
            
            wordCountValueLabel.topAnchor.constraint(equalTo: wordCountLabel.bottomAnchor, constant: 10),
            wordCountValueLabel.centerXAnchor.constraint(equalTo: scoreContainer.centerXAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: scoreContainer.bottomAnchor, constant: 40),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            playAgainButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 40),
            playAgainButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            playAgainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            playAgainButton.heightAnchor.constraint(equalToConstant: 60),
            
            mainMenuButton.topAnchor.constraint(equalTo: playAgainButton.bottomAnchor, constant: 20),
            mainMenuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            mainMenuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            mainMenuButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Add animations
        animateUI()
    }
    
    private func getMessageForScore(_ score: Int) -> String {
        // 使用真实的单词数而不是计算值
        let words = wordCount
        
        switch words {
        case 0...3:
            return "Keep practicing! You can do better next time."
        case 4...7:
            return "Good effort! Your vocabulary is growing."
        case 8...12:
            return "Great job! You have a good command of words."
        case 13...18:
            return "Excellent! You're a word master."
        default:
            return "Incredible! You have an amazing vocabulary!"
        }
    }
    
    private func animateUI() {
        // Initial states
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransform(translationX: 0, y: -20)
        
        scoreContainer.alpha = 0
        scoreContainer.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        messageLabel.alpha = 0
        
        playAgainButton.alpha = 0
        playAgainButton.transform = CGAffineTransform(translationX: 0, y: 20)
        
        mainMenuButton.alpha = 0
        mainMenuButton.transform = CGAffineTransform(translationX: 0, y: 20)
        
        // Animate in sequence
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [], animations: {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = .identity
        })
        
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.scoreContainer.alpha = 1
            self.scoreContainer.transform = .identity
        })
        
        UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: {
            self.messageLabel.alpha = 1
        })
        
        UIView.animate(withDuration: 0.5, delay: 1.3, options: [], animations: {
            self.playAgainButton.alpha = 1
            self.playAgainButton.transform = .identity
        })
        
        UIView.animate(withDuration: 0.5, delay: 1.5, options: [], animations: {
            self.mainMenuButton.alpha = 1
            self.mainMenuButton.transform = .identity
        })
    }
    
    private func addConfetti() {
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: view.bounds.width / 2, y: -20)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: view.bounds.width, height: 1)
        
        let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemYellow, .systemPurple, .systemOrange]
        var cells: [CAEmitterCell] = []
        
        for color in colors {
            let cell = CAEmitterCell()
            cell.birthRate = 4
            cell.lifetime = 10
            cell.lifetimeRange = 0
            cell.velocity = 150
            cell.velocityRange = 50
            cell.emissionLongitude = .pi
            cell.emissionRange = .pi / 4
            cell.spin = 3
            cell.spinRange = 2
            cell.color = color.cgColor
            cell.contents = UIImage(systemName: "star.fill")?.cgImage
            cell.scaleRange = 0.3
            cell.scale = 0.1
            
            cells.append(cell)
        }
        
        emitter.emitterCells = cells
        view.layer.addSublayer(emitter)
        
        // Stop emission after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            emitter.birthRate = 0
        }
    }
    
    // MARK: - Button Actions
    
    @objc private func playAgainButtonTapped() {
        SoundManager.shared.play(.click)
        
        // 保存游戏模式到本地变量，确保在dismiss完成回调中可用
        let currentGameMode = self.gameMode
        print("Play Again按钮被点击，游戏模式: \(currentGameMode)")
        
        // 在dismiss之前先找到GameViewController
        if let navigationController = self.presentingViewController as? UINavigationController,
           let gameVC = navigationController.topViewController as? GameViewController {
            
            // 立即在主线程上调用startGame - 确保无论是什么模式都会重新开始游戏
            print("找到GameViewController，即将调用startGame，重新开始\(currentGameMode == .time ? "限时模式" : "无尽模式")游戏")
            
            // 关闭当前视图
            dismiss(animated: true) { [weak gameVC, currentGameMode] in
                // 在dismiss完成后重新开始游戏，确保UI状态已经更新
                DispatchQueue.main.async {
                    gameVC?.startGame(mode: currentGameMode)
                }
            }
        } else {
            // 如果找不到GameViewController，只关闭当前视图
            print("无法找到GameViewController")
            dismiss(animated: true)
        }
    }
    
    @objc private func mainMenuButtonTapped() {
        SoundManager.shared.play(.click)
        
        print("Main Menu按钮被点击")
        
        // 在dismiss之前检查是否能找到导航控制器
        if let navigationController = self.presentingViewController as? UINavigationController {
            print("找到NavigationController")
            
            // 检查当前的顶层视图控制器是否是GameViewController
            if let gameVC = navigationController.topViewController as? GameViewController {
                // 如果是GameViewController，在返回主菜单前先停止游戏
                print("找到GameViewController，停止游戏")
                gameVC.endGame()
                
                // 关闭结算页面
                dismiss(animated: true) {
                    // 在dismiss完成后，将GameViewController弹出导航栈，返回到MainMenuViewController
                    navigationController.popViewController(animated: true)
                }
                return
            }
            
            // 关闭当前视图
            dismiss(animated: true)
        } else {
            print("无法找到NavigationController")
            dismiss(animated: true)
        }
    }
} 