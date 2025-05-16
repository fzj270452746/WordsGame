import UIKit

public class GameViewController: UIViewController {
    
    // UI Elements
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    private let wordsLabel = UILabel()
    private let wordCountLabel = UILabel()    // 添加单词数量标签
    private let currentWordTextField = UITextField()
    private let spinButton = RoundedButton(title: "SPIN", type: RoundedButton.RoundedButtonStyle.danger)
    private let submitButton = RoundedButton(title: "SUBMIT", type: RoundedButton.RoundedButtonStyle.primary)
    private let letterTilesStackView = UIStackView()
    private let headerView = UIView()
    private let headerContentView = UIView()
    private let backButton = UIButton()
    private let instructionLabel = UILabel()
    
    // Game state
    private var gameMode: GameMode = .time
    private var gameManager = GameManager()
    private var letterTileViews: [LetterTileView] = []
    private var selectedLetters: [Character] = []
    private var isValidatingWord = false
    private var currentScore: Int = 0   // Track the current score
    private var currentWordCount: Int = 0 // 跟踪完成的单词数量
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        gameManager.delegate = self
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 当视图即将消失时清理背景资源
        if isMovingFromParent {
            view.clearBackgroundImage()
        }
    }
    
    public func startGame(mode: GameMode) {
        print("GameViewController.startGame被调用，游戏模式: \(mode)，时间限制: \(mode.timeLimit ?? 0)")
        
        // Reset game mode
        self.gameMode = mode
        titleLabel.text = mode.title
        
        // Reset UI state
        selectedLetters = []
        currentWordTextField.text = ""
        instructionLabel.text = "Press SPIN for new letters"
        instructionLabel.textColor = .white
        
        // Reset button states
        submitButton.isEnabled = true
        spinButton.isEnabled = true
        spinButton.alpha = 1.0
        isValidatingWord = false
        
        // Reset displayed score and word count
        currentScore = 0
        currentWordCount = 0
        wordsLabel.text = "0"
        wordCountLabel.text = "0"
        
        // Explicitly set timer display for time mode
        if let timeLimit = mode.timeLimit {
            timeLabel.text = "\(Int(timeLimit))"
            titleLabel.text = "TIME MODE"
        } else {
            timeLabel.text = "∞"  // 使用无限符号表示无限模式
            titleLabel.text = "CHALLENGE MODE"
        }
        
        // Clear any temporary views or activity indicators
        view.subviews.compactMap { $0 as? UIActivityIndicatorView }.forEach { $0.removeFromSuperview() }
        view.subviews.compactMap { $0 as? UILabel }.filter { $0 != titleLabel && $0 != timeLabel && 
                                                                  $0 != wordsLabel && $0 != wordCountLabel && 
                                                                  $0 != instructionLabel && $0 != currentWordTextField }
                                        .forEach { $0.removeFromSuperview() }
        
        // Clear letter tiles
        letterTileViews.forEach { $0.removeFromSuperview() }
        letterTileViews = []
        letterTilesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // u91cdu8981uff1au521bu5efau5168u65b0u7684GameManageru5b9eu4f8bu786eu4fddu6240u6709u72b6u6001u90fdu88abu91cdu7f6e
        gameManager = GameManager()
        gameManager.delegate = self
        
        // Start new game with GameManager (without spinning slot machine)
        gameManager.startGame(mode: mode)
        
        // Trigger the spin action right away to generate the initial letters
        spinButtonTapped()
    }
    
    public func endGame() {
        print("GameViewController.endGame被调用")
        
        // 保存分数到本地数据库（如果分数大于0）
        if currentScore > 0 {
            let scoreManager = ScoreManager()
            scoreManager.saveScore(currentScore, wordCount: currentWordCount, forMode: gameMode)
        }
        
        // 停止游戏管理器
        gameManager.endGame()
        
        // 清理UI元素
        letterTileViews.forEach { $0.removeFromSuperview() }
        letterTileViews = []
        letterTilesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 重置所有状态变量
        selectedLetters = []
        currentWordTextField.text = ""
        
        // 停止任何正在进行的动画
        view.layer.removeAllAnimations()
        letterTilesStackView.layer.removeAllAnimations()
        
        // 移除任何临时视图
        view.subviews.compactMap { $0 as? UIActivityIndicatorView }.forEach { $0.removeFromSuperview() }
        
        print("游戏已完全停止，资源已清理")
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.appBackground
        
        // 添加背景图片
        view.addBackgroundImage(named: "bg_game")
        
        // 设置渐变背景（应用在背景图片之上）
        setupBackground()
        
        // 设置头部区域
        setupHeader()
        
        // 设置老虎机UI
        setupSlotMachine()
        
        // 设置单词输入
        setupWordInput()
        
        // 添加浮动元素
        addFloatingElements()
    }
    
    private func setupBackground() {
        // Add background gradient
        view.applyGradient(colors: [
            UIColor(red: 21/255, green: 21/255, blue: 30/255, alpha: 1.0),
            UIColor(red: 40/255, green: 40/255, blue: 80/255, alpha: 1.0)
        ])
        
        // Add slot machine background images
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
    }
    
    private func setupHeader() {
        // Header container
        headerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        // Header content
        headerContentView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerContentView)
        
        // Back button
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        headerContentView.addSubview(backButton)
        
        // Title label
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerContentView.addSubview(titleLabel)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            headerContentView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5),
            headerContentView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerContentView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            headerContentView.heightAnchor.constraint(equalToConstant: 44),
            
            backButton.leadingAnchor.constraint(equalTo: headerContentView.leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: headerContentView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerContentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerContentView.centerYAnchor),
        ])
        
        // Stats container
        let statsContainer = UIView()
        statsContainer.backgroundColor = UIColor.cardBackground
        statsContainer.layer.cornerRadius = 15
        statsContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statsContainer)
        
        // 将statsContainer分为三部分：时间、分数、单词数
        
        // Time label container - 占1/3宽度
        let timeContainer = UIView()
        timeContainer.translatesAutoresizingMaskIntoConstraints = false
        statsContainer.addSubview(timeContainer)
        
        let timeHeaderLabel = UILabel()
        timeHeaderLabel.text = "TIME"
        timeHeaderLabel.textColor = .white
        timeHeaderLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        timeHeaderLabel.textAlignment = .center
        timeHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        timeContainer.addSubview(timeHeaderLabel)
        
        timeLabel.textColor = UIColor.orange
        timeLabel.font = UIFont.boldSystemFont(ofSize: 28)
        timeLabel.textAlignment = .center
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeContainer.addSubview(timeLabel)
        
        // Words label container - 占1/3宽度
        let wordsContainer = UIView()
        wordsContainer.translatesAutoresizingMaskIntoConstraints = false
        statsContainer.addSubview(wordsContainer)
        
        let wordsHeaderLabel = UILabel()
        wordsHeaderLabel.text = "SCORE"
        wordsHeaderLabel.textColor = .white
        wordsHeaderLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        wordsHeaderLabel.textAlignment = .center
        wordsHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        wordsContainer.addSubview(wordsHeaderLabel)
        
        wordsLabel.text = "0"
        wordsLabel.textColor = UIColor(red: 87/255, green: 201/255, blue: 255/255, alpha: 1)
        wordsLabel.font = UIFont.boldSystemFont(ofSize: 28)
        wordsLabel.textAlignment = .center
        wordsLabel.translatesAutoresizingMaskIntoConstraints = false
        wordsContainer.addSubview(wordsLabel)
        
        // Word count container - 占1/3宽度
        let wordCountContainer = UIView()
        wordCountContainer.translatesAutoresizingMaskIntoConstraints = false
        statsContainer.addSubview(wordCountContainer)
        
        let wordCountHeaderLabel = UILabel()
        wordCountHeaderLabel.text = "WORDS"
        wordCountHeaderLabel.textColor = .white
        wordCountHeaderLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        wordCountHeaderLabel.textAlignment = .center
        wordCountHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        wordCountContainer.addSubview(wordCountHeaderLabel)
        
        wordCountLabel.text = "0"
        wordCountLabel.textColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1) // 黄色
        wordCountLabel.font = UIFont.boldSystemFont(ofSize: 28)
        wordCountLabel.textAlignment = .center
        wordCountLabel.translatesAutoresizingMaskIntoConstraints = false
        wordCountContainer.addSubview(wordCountLabel)
        
        NSLayoutConstraint.activate([
            statsContainer.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            statsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statsContainer.heightAnchor.constraint(equalToConstant: 100),
            
            // Time container - 左侧1/3
            timeContainer.leadingAnchor.constraint(equalTo: statsContainer.leadingAnchor),
            timeContainer.topAnchor.constraint(equalTo: statsContainer.topAnchor),
            timeContainer.bottomAnchor.constraint(equalTo: statsContainer.bottomAnchor),
            timeContainer.widthAnchor.constraint(equalTo: statsContainer.widthAnchor, multiplier: 0.33),
            
            timeHeaderLabel.topAnchor.constraint(equalTo: timeContainer.topAnchor, constant: 15),
            timeHeaderLabel.centerXAnchor.constraint(equalTo: timeContainer.centerXAnchor),
            
            timeLabel.topAnchor.constraint(equalTo: timeHeaderLabel.bottomAnchor, constant: 5),
            timeLabel.centerXAnchor.constraint(equalTo: timeContainer.centerXAnchor),
            
            // Score container - 中间1/3
            wordsContainer.leadingAnchor.constraint(equalTo: timeContainer.trailingAnchor),
            wordsContainer.topAnchor.constraint(equalTo: statsContainer.topAnchor),
            wordsContainer.bottomAnchor.constraint(equalTo: statsContainer.bottomAnchor),
            wordsContainer.widthAnchor.constraint(equalTo: statsContainer.widthAnchor, multiplier: 0.33),
            
            wordsHeaderLabel.topAnchor.constraint(equalTo: wordsContainer.topAnchor, constant: 15),
            wordsHeaderLabel.centerXAnchor.constraint(equalTo: wordsContainer.centerXAnchor),
            
            wordsLabel.topAnchor.constraint(equalTo: wordsHeaderLabel.bottomAnchor, constant: 5),
            wordsLabel.centerXAnchor.constraint(equalTo: wordsContainer.centerXAnchor),
            
            // Word count container - 右侧1/3
            wordCountContainer.leadingAnchor.constraint(equalTo: wordsContainer.trailingAnchor),
            wordCountContainer.topAnchor.constraint(equalTo: statsContainer.topAnchor),
            wordCountContainer.bottomAnchor.constraint(equalTo: statsContainer.bottomAnchor),
            wordCountContainer.trailingAnchor.constraint(equalTo: statsContainer.trailingAnchor),
            
            wordCountHeaderLabel.topAnchor.constraint(equalTo: wordCountContainer.topAnchor, constant: 15),
            wordCountHeaderLabel.centerXAnchor.constraint(equalTo: wordCountContainer.centerXAnchor),
            
            wordCountLabel.topAnchor.constraint(equalTo: wordCountHeaderLabel.bottomAnchor, constant: 5),
            wordCountLabel.centerXAnchor.constraint(equalTo: wordCountContainer.centerXAnchor),
        ])
    }
    
    private func setupSlotMachine() {
        // Letter tiles container
        letterTilesStackView.axis = .horizontal
        letterTilesStackView.distribution = .fillEqually
        letterTilesStackView.spacing = 10
        letterTilesStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(letterTilesStackView)
        
        // Spin button
        spinButton.translatesAutoresizingMaskIntoConstraints = false
        spinButton.addTarget(self, action: #selector(spinButtonTapped), for: .touchUpInside)
        view.addSubview(spinButton)
        
        NSLayoutConstraint.activate([
            letterTilesStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            letterTilesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            letterTilesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            letterTilesStackView.heightAnchor.constraint(equalToConstant: 150),
            
            spinButton.topAnchor.constraint(equalTo: letterTilesStackView.bottomAnchor, constant: 30),
            spinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinButton.widthAnchor.constraint(equalToConstant: 200),
            spinButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupWordInput() {
        // Instruction label
        instructionLabel.text = "Please Input words"
        instructionLabel.textColor = .white
        instructionLabel.font = UIFont.systemFont(ofSize: 18)
        instructionLabel.textAlignment = .center
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(instructionLabel)
        
        // Current word field
        currentWordTextField.borderStyle = .roundedRect
        currentWordTextField.backgroundColor = UIColor.black
        currentWordTextField.textColor = .white
        currentWordTextField.textAlignment = .center
        currentWordTextField.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        currentWordTextField.isUserInteractionEnabled = false
        currentWordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currentWordTextField)
        
        // Submit button
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: spinButton.bottomAnchor, constant: 30),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            currentWordTextField.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20),
            currentWordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            currentWordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            currentWordTextField.heightAnchor.constraint(equalToConstant: 60),
            
            submitButton.topAnchor.constraint(equalTo: currentWordTextField.bottomAnchor, constant: 30),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            submitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func addFloatingElements() {
        // Add floating coins/bubbles
        let numberOfElements = 8
        
        for _ in 0..<numberOfElements {
            addFloatingBubble()
        }
    }
    
    private func addFloatingBubble() {
        let bubble = UIView()
        let size = CGFloat.random(in: 15...40)
        bubble.backgroundColor = UIColor.yellow.withAlphaComponent(0.2)
        bubble.layer.cornerRadius = size / 2
        
        // Random starting position
        let startX = CGFloat.random(in: -20...(view.bounds.width + 20))
        let startY = view.bounds.height + size
        
        bubble.frame = CGRect(x: startX, y: startY, width: size, height: size)
        view.insertSubview(bubble, at: 0) // Add at the back
        
        // Animate the bubble floating up
        let duration = TimeInterval.random(in: 8...12)
        let endY = -size
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear], animations: {
            bubble.frame.origin.y = endY
        }) { _ in
            bubble.removeFromSuperview()
            self.addFloatingBubble() // Add a new bubble when this one finishes
        }
    }
    
    private func updateLetterTiles(with tiles: [LetterTile]) {
        // u6e05u9664u73b0u6709u5b57u6bcdu89c6u56fe
        letterTileViews.forEach { $0.removeFromSuperview() }
        letterTileViews = []
        letterTilesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // u91cdu7f6eu9009u62e9u72b6u6001
        selectedLetters = []
        currentWordTextField.text = ""
        
        // u521bu5efau65b0u7684u5b57u6bcdu74e6u7247u89c6u56fe
        for tile in tiles {
            let tileView = LetterTileView(tile: tile)
            tileView.translatesAutoresizingMaskIntoConstraints = false
            tileView.heightAnchor.constraint(equalToConstant: 140).isActive = true
            tileView.isSelected = false
            tileView.isUsed = false  // u786eu4fddu65b0u74e6u7247u672au88abu6807u8bb0u4e3au5df2u4f7fu7528
            
            // u6dfbu52a0u70b9u51fbu5904u7406
            tileView.onTap = { tappedTile in
                self.letterTileTapped(tappedTile)
            }
            
            letterTileViews.append(tileView)
            letterTilesStackView.addArrangedSubview(tileView)
        }
        
        // u4e3au5b57u6bcdu74e6u7247u6dfbu52a0u51fau73b0u52a8u753b
        letterTileViews.enumerated().forEach { (index, tileView) in
            tileView.transform = CGAffineTransform(translationX: 0, y: 20)
            tileView.alpha = 0
            
            UIView.animate(withDuration: 0.3, delay: Double(index) * 0.05, options: [], animations: {
                tileView.transform = .identity
                tileView.alpha = 1
            })
        }
    }
    
    private func letterTileTapped(_ tileView: LetterTileView) {
        // 播放音效
        SoundManager.shared.play(.letterSelect)
        
        // Skip if tile is already marked as used
        if tileView.isUsed {
            return
        }
        
        // 使用tileView对象本身作为唯一标识，而不是仅使用字母
        // 当tileView被选中时，将其添加到选中列表中
        if tileView.isSelected {
            // 字母被选中，添加到输入框
            let letter = tileView.letter
            selectedLetters.append(letter)
        } else {
            // 字母取消选中，从选中列表中移除最后一个匹配的字母
            let letter = tileView.letter
            if let index = selectedLetters.lastIndex(of: letter) {
                selectedLetters.remove(at: index)
            }
        }
        
        // 更新输入框内容
        let wordString = selectedLetters.map { String($0) }.joined()
        currentWordTextField.text = wordString
        
        // 打印调试信息
        print("字母点击: \(tileView.letter) - 选中状态: \(tileView.isSelected)")
        print("已选字母: \(selectedLetters) - 文本框内容: \(currentWordTextField.text ?? "")")
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        SoundManager.shared.play(.click)
        
        // 如果是无尽模式且分数为0，直接退出游戏无需确认
        if gameMode == .challenge && currentScore == 0 {
            endGame()
            navigationController?.popViewController(animated: true)
            return
        }
        
        // 否则显示确认对话框
        let alert = UIAlertController(title: "End Game?", message: "Are you sure you want to end the current game?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
            self?.endGame()
            self?.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func spinButtonTapped() {
        // Prevent spinning while validating word
        guard !isValidatingWord else { return }
        
        SoundManager.shared.play(.spin)
        
        // u7981u7528SPINu6309u94aeu76f4u5230u52a8u753bu5b8cu6210
        spinButton.isEnabled = false
        spinButton.alpha = 0.5
        submitButton.isEnabled = false
        
        // u6e05u9664u73b0u6709u5b57u6bcdu89c6u56fe
        letterTileViews.forEach { $0.removeFromSuperview() }
        letterTileViews = []
        letterTilesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // u91cdu7f6eu9009u62e9u72b6u6001
        selectedLetters = []
        currentWordTextField.text = ""
        
        // u521bu5efau65b0u7684u56fau5b9au683cu5b50
        let numberOfReels = 5
        var spinTimers: [Timer] = []
        
        // u4e3au6bcfu4e2areelu521bu5efau4e00u4e2au683cu5b50
        for i in 0..<numberOfReels {
            // u521bu5efau4e00u4e2au56fau5b9au7684u683cu5b50u663eu793au968fu673au5b57u6bcd
            let initialTile = LetterTile(letter: randomLetter(), color: LetterTile.randomColor())
            let tileView = LetterTileView(tile: initialTile)
            tileView.translatesAutoresizingMaskIntoConstraints = false
            tileView.heightAnchor.constraint(equalToConstant: 140).isActive = true
            tileView.isUserInteractionEnabled = false // u52a8u753bu671fu95f4u7981u7528u4ea4u4e92
            letterTilesStackView.addArrangedSubview(tileView)
            
            // u4e3au6bcfu4e2au683cu5b50u521bu5efau5b9au65f6u5668u4ee5u968fu673au65f6u95f4u95f4u9694u5207u6362u5b57u6bcd
            let spinInterval = 0.1 // u5207u6362u5b57u6bcdu7684u65f6u95f4u95f4u9694
            let spinDuration = 1.0 + Double(i) * 0.3 // u8ba9u6bcfu4e2au683cu5b50u7684u65cbu8f6cu65f6u95f4u9010u6e10u589eu52a0
            var currentSpinTime: TimeInterval = 0
            
            // 使用弱引用捕获tileView以避免循环引用
            weak var weakTileView = tileView
            
            // 创建一个函数来更新字母，这样可以先声明timer变量
            let updateLetter: (Timer) -> Void = { [weak self] currentTimer in
                guard let self = self, let tileView = weakTileView else { return }
                
                // u66f4u65b0u5b57u6bcd
                let newTile = LetterTile(letter: self.randomLetter(), color: tileView.backgroundColor ?? LetterTile.randomColor())
                tileView.update(with: newTile)
                
                // u6dfbu52a0u4e00u4e2au5febu901fu7684u7f29u653eu52a8u753bu63d0u5347u89c6u89c9u6548u679c
                UIView.animate(withDuration: spinInterval * 0.5, animations: {
                    tileView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }) { _ in
                    UIView.animate(withDuration: spinInterval * 0.5) {
                        tileView.transform = .identity
                    }
                }
                
                // u8ba1u7b97u5f53u524du65cbu8f6cu65f6u95f4
                currentSpinTime += spinInterval
                
                // u5982u679cu8fbeu5230u6307u5b9au7684u65cbu8f6cu65f6u95f4uff0cu505cu6b62u8fd9u4e2areelu7684u65cbu8f6c
                if currentSpinTime >= spinDuration {
                    self.stopSpinning(tileView: tileView, timer: currentTimer)
                }
            }
            
            // 先创建timer变量，然后再设置其值
            let timer = Timer.scheduledTimer(withTimeInterval: spinInterval, repeats: true) { timer in
                updateLetter(timer)
            }
            
            spinTimers.append(timer)
        }
        
        // u5728u6240u6709u683cu5b50u505cu6b62u65cbu8f6cu540eu751fu6210u6700u7ec8u7684u5b57u6bcdu74e6u7247
        let maxDuration = 1.0 + Double(numberOfReels - 1) * 0.3 + 0.2
        DispatchQueue.main.asyncAfter(deadline: .now() + maxDuration) {
            // u7ec8u6b62u6240u6709u5b9au65f6u5668
            spinTimers.forEach { $0.invalidate() }
            
            // u52a8u753bu7ed3u675fu540eu91cdu65b0u542fu7528u6309u94ae
            self.spinButton.isEnabled = true
            self.spinButton.alpha = 1.0
            self.submitButton.isEnabled = true
            
            // u542fu7528u6240u6709u5b57u6bcdu74e6u7247u7684u4ea4u4e92
            var finalTiles: [LetterTile] = []
            self.letterTilesStackView.arrangedSubviews.forEach { view in
                if let tileView = view as? LetterTileView {
                    // u5c06u5b57u6bcdu74e6u7247u6dfbu52a0u5230u7ef4u62a4u7684u6570u7ec4u4e2d
                    self.letterTileViews.append(tileView)
                    
                    // Create a new LetterTile for each displayed letter and add to finalTiles
                    let tile = LetterTile(letter: tileView.letter, color: tileView.backgroundColor ?? LetterTile.randomColor())
                    finalTiles.append(tile)
                    
                    // u542fu7528u4ea4u4e92
                    tileView.isUserInteractionEnabled = true
                    // u6dfbu52a0u70b9u51fbu4e8bu4ef6
                    tileView.onTap = { tappedTile in
                        self.letterTileTapped(tappedTile)
                    }
                }
            }
            
            // Update GameManager's currentTiles with the letters actually displayed in the UI
            self.gameManager.updateCurrentTiles(finalTiles)
            
            // u66f4u65b0u6307u5357u6587u672c
            self.instructionLabel.text = "Select letters to form a word"
            self.instructionLabel.textColor = .white
        }
    }
    
    // u751fu6210u968fu673au5b57u6bcd
    private func randomLetter() -> Character {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return letters.randomElement() ?? "A"
    }
    
    // u505cu6b62u683cu5b50u7684u65cbu8f6c
    private func stopSpinning(tileView: LetterTileView, timer: Timer) {
        timer.invalidate()
        
        // u505cu6b62u65f6u7684u52a0u5f3au52a8u753bu6548u679c
        UIView.animate(withDuration: 0.2, animations: {
            tileView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                tileView.transform = .identity
            }
        }
        
        // u64adu653eu683cu5b50u505cu6b62u7684u58f0u97f3
        SoundManager.shared.play(.letterSelect)
    }
    
    @objc private func submitButtonTapped() {
        guard !selectedLetters.isEmpty else {
            // Show error if no letters selected
            instructionLabel.text = "Please select letters first!"
            instructionLabel.textColor = UIColor.red
            instructionLabel.shake()
            
            // Reset after 1.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.instructionLabel.text = "Press SPIN for new letters"
                self.instructionLabel.textColor = .white
            }
            return
        }
        
        let word = String(selectedLetters)
        
        // Show loading indicator
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: submitButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor)
        ])
        
        // Disable the submit button while validating
        submitButton.isEnabled = false
        
        // Disable spin button and set validating flag
        isValidatingWord = true
        spinButton.isEnabled = false
        spinButton.alpha = 0.5
        
        // Update instruction label
        instructionLabel.text = "Validating word..."
        instructionLabel.textColor = .white
        
        // Submit word for validation
        gameManager.submitWord(word)
    }
}

// MARK: - GameManagerDelegate
extension GameViewController: GameManagerDelegate {
    public func gameDidUpdateTime(_ remainingTime: Int) {
        timeLabel.text = "\(remainingTime)"
        
        // Add color animation for last 10 seconds
        if remainingTime <= 10 {
            UIView.animate(withDuration: 0.5, animations: {
                self.timeLabel.textColor = UIColor.red
            }) { _ in
                UIView.animate(withDuration: 0.5) {
                    self.timeLabel.textColor = UIColor.orange
                }
            }
        }
    }
    
    public func gameDidUpdateScore(_ score: Int) {
        // Update the current score
        currentScore = score
        
        // Display the actual score value
        wordsLabel.text = "\(score)"
        
        // Animate the words label
        wordsLabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.3) {
            self.wordsLabel.transform = .identity
        }
    }
    
    public func gameDidFinish(score: Int) {
        SoundManager.shared.play(.gameOver)
        
        // Show game over screen - 同时传递分数和单词数
        let resultsVC = GameResultsViewController(score: currentScore, wordCount: currentWordCount, mode: gameMode)
        resultsVC.modalPresentationStyle = .fullScreen
        present(resultsVC, animated: true)
    }
    
    public func gameDidUpdateWordCount(_ count: Int) {
        // 更新当前单词数
        currentWordCount = count
        
        // 更新UI显示
        wordCountLabel.text = "\(count)"
        
        // 添加动画效果
        wordCountLabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.3) {
            self.wordCountLabel.transform = .identity
        }
    }
    
    public func gameDidGenerateNewTiles(_ tiles: [LetterTile]) {
        updateLetterTiles(with: tiles)
    }
    
    public func gameDidValidateWord(isValid: Bool, errorMessage: String?, pointsEarned: Int = 10) {
        // Re-enable the submit button
        submitButton.isEnabled = true
        
        // Re-enable the spin button and reset validating flag
        isValidatingWord = false
        spinButton.isEnabled = true
        spinButton.alpha = 1.0
        
        // Remove any activity indicator
        view.subviews.compactMap { $0 as? UIActivityIndicatorView }.forEach { $0.removeFromSuperview() }
        
        if isValid {
            SoundManager.shared.play(.success)
            
            // Mark selected tiles as used so they can't be reused
            for tileView in letterTileViews where tileView.isSelected {
                tileView.isUsed = true
                tileView.isSelected = false
            }
            
            // Reset selected letters
            selectedLetters = []
            currentWordTextField.text = ""
            
            // Show success animation with points earned
            let successLabel = UILabel()
            successLabel.text = "+\(pointsEarned)"
            successLabel.textColor = UIColor.green
            successLabel.font = UIFont.boldSystemFont(ofSize: 24)
            successLabel.textAlignment = .center
            successLabel.alpha = 0
            successLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(successLabel)
            
            NSLayoutConstraint.activate([
                successLabel.centerXAnchor.constraint(equalTo: currentWordTextField.centerXAnchor),
                successLabel.centerYAnchor.constraint(equalTo: currentWordTextField.centerYAnchor)
            ])
            
            UIView.animate(withDuration: 0.5, animations: {
                successLabel.alpha = 1
                successLabel.transform = CGAffineTransform(translationX: 0, y: -30)
            }) { _ in
                UIView.animate(withDuration: 0.3, animations: {
                    successLabel.alpha = 0
                }) { _ in
                    successLabel.removeFromSuperview()
                }
            }
            
            // Update instruction label with bonus info if applicable
            if pointsEarned > 10 {
                instructionLabel.text = "Great job! +\(pointsEarned) combo bonus! Spin for new letters."
            } else {
                instructionLabel.text = "Great job! +\(pointsEarned) points! Spin for new letters."
            }
            instructionLabel.textColor = UIColor.green
            
            // Reset after 1.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.instructionLabel.text = "Press SPIN for new letters"
                self.instructionLabel.textColor = .white
            }
        } else {
            SoundManager.shared.play(.fail)
            
            // Show error animation
            instructionLabel.text = errorMessage ?? "Invalid word!"
            instructionLabel.textColor = UIColor.red
            instructionLabel.shake()
            
            // Reset after 1.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.instructionLabel.text = "Press SPIN for new letters"
                self.instructionLabel.textColor = .white
            }
        }
    }
} 
