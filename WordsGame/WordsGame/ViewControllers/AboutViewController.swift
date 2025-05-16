import UIKit

class AboutViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let backButton = UIButton()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let howToPlayLabel = UILabel()
    private let gameModesLabel = UILabel()
    private let versionLabel = UILabel()
    private let feedbackLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 当视图即将消失时清理背景资源
        if isMovingFromParent {
            view.clearBackgroundImage()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.appBackground
        
        // 添加背景图片
        view.addBackgroundImage(named: "bg_about")
        
        // 应用渐变（应用在背景图片之上）
        view.applyGradient(colors: [
            UIColor(red: 21/255, green: 21/255, blue: 30/255, alpha: 1.0),
            UIColor(red: 40/255, green: 40/255, blue: 80/255, alpha: 1.0)
        ])
        
        // 设置头部
        setupHeader()
        
        // 设置滚动视图
        setupScrollView()
        
        // 设置内容
        setupContent()
    }
    
    private func setupHeader() {
        // Header container
        let headerView = UIView()
        headerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        // Header content
        let headerContentView = UIView()
        headerContentView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerContentView)
        
        // Back button
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        headerContentView.addSubview(backButton)
        
        // Title label
        titleLabel.text = "ABOUT"
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
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupContent() {
        // Create section: How to play
        let howToPlayContainer = createSectionContainer()
        contentView.addSubview(howToPlayContainer)
        
        howToPlayLabel.text = "HOW TO PLAY"
        howToPlayLabel.textColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1.0)
        howToPlayLabel.font = UIFont.boldSystemFont(ofSize: 22)
        howToPlayLabel.translatesAutoresizingMaskIntoConstraints = false
        howToPlayContainer.addSubview(howToPlayLabel)
        
        let howToPlayText = UILabel()
        howToPlayText.text = """
        1. Spin the slot machine to get 5 random letters.
        2. Form valid English words using these letters.
        3. Submit your word - it must only use the letters shown.
        4. Words are validated against an online dictionary API.
        5. In Time Mode, complete as many words as possible in 2 minutes.
        6. In Challenge Mode, keep playing with no time limit.
        """
        howToPlayText.textColor = .white
        howToPlayText.font = UIFont.systemFont(ofSize: 16)
        howToPlayText.numberOfLines = 0
        howToPlayText.translatesAutoresizingMaskIntoConstraints = false
        howToPlayContainer.addSubview(howToPlayText)
        
        // Create section: Game Modes
        let gameModesContainer = createSectionContainer()
        contentView.addSubview(gameModesContainer)
        
        gameModesLabel.text = "GAME MODES"
        gameModesLabel.textColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1.0)
        gameModesLabel.font = UIFont.boldSystemFont(ofSize: 22)
        gameModesLabel.translatesAutoresizingMaskIntoConstraints = false
        gameModesContainer.addSubview(gameModesLabel)
        
        let gameModesText = UILabel()
        gameModesText.text = """
        TIME MODE: Complete as many words as possible in 2 minutes.
        
        CHALLENGE MODE: No time limit, keep playing to achieve your best score.
        
        OFFLINE MODE: The game works without internet too! It will use a simplified dictionary when no connection is available.
        """
        gameModesText.textColor = .white
        gameModesText.font = UIFont.systemFont(ofSize: 16)
        gameModesText.numberOfLines = 0
        gameModesText.translatesAutoresizingMaskIntoConstraints = false
        gameModesContainer.addSubview(gameModesText)
        
        // Create section: Feedback
        let feedbackContainer = createSectionContainer()
        contentView.addSubview(feedbackContainer)
        
        feedbackLabel.text = "FEEDBACK"
        feedbackLabel.textColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1.0)
        feedbackLabel.font = UIFont.boldSystemFont(ofSize: 22)
        feedbackLabel.translatesAutoresizingMaskIntoConstraints = false
        feedbackContainer.addSubview(feedbackLabel)
        
        let feedbackText = UILabel()
        feedbackText.text = """
        Have questions or suggestions?
        
        Email us at: support@slotwords.com
        """
        feedbackText.textColor = .white
        feedbackText.font = UIFont.systemFont(ofSize: 16)
        feedbackText.numberOfLines = 0
        feedbackText.translatesAutoresizingMaskIntoConstraints = false
        feedbackContainer.addSubview(feedbackText)
        
        // Create section: Version
        let versionContainer = createSectionContainer()
        contentView.addSubview(versionContainer)
        
        versionLabel.text = "VERSION"
        versionLabel.textColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1.0)
        versionLabel.font = UIFont.boldSystemFont(ofSize: 22)
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        versionContainer.addSubview(versionLabel)
        
        let versionText = UILabel()
        versionText.text = """
        2025 Slot Words Game v1.0
        
        © 2025 Slot Words Game
        """
        versionText.textColor = .white
        versionText.font = UIFont.systemFont(ofSize: 16)
        versionText.numberOfLines = 0
        versionText.translatesAutoresizingMaskIntoConstraints = false
        versionContainer.addSubview(versionText)
        
        // Set constraints for all sections
        NSLayoutConstraint.activate([
            // How to play section
            howToPlayContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            howToPlayContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            howToPlayContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            howToPlayLabel.topAnchor.constraint(equalTo: howToPlayContainer.topAnchor, constant: 20),
            howToPlayLabel.leadingAnchor.constraint(equalTo: howToPlayContainer.leadingAnchor, constant: 20),
            
            howToPlayText.topAnchor.constraint(equalTo: howToPlayLabel.bottomAnchor, constant: 10),
            howToPlayText.leadingAnchor.constraint(equalTo: howToPlayContainer.leadingAnchor, constant: 20),
            howToPlayText.trailingAnchor.constraint(equalTo: howToPlayContainer.trailingAnchor, constant: -20),
            howToPlayText.bottomAnchor.constraint(equalTo: howToPlayContainer.bottomAnchor, constant: -20),
            
            // Game modes section
            gameModesContainer.topAnchor.constraint(equalTo: howToPlayContainer.bottomAnchor, constant: 20),
            gameModesContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            gameModesContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            gameModesLabel.topAnchor.constraint(equalTo: gameModesContainer.topAnchor, constant: 20),
            gameModesLabel.leadingAnchor.constraint(equalTo: gameModesContainer.leadingAnchor, constant: 20),
            
            gameModesText.topAnchor.constraint(equalTo: gameModesLabel.bottomAnchor, constant: 10),
            gameModesText.leadingAnchor.constraint(equalTo: gameModesContainer.leadingAnchor, constant: 20),
            gameModesText.trailingAnchor.constraint(equalTo: gameModesContainer.trailingAnchor, constant: -20),
            gameModesText.bottomAnchor.constraint(equalTo: gameModesContainer.bottomAnchor, constant: -20),
            
            // Feedback section (now directly follows game modes section)
            feedbackContainer.topAnchor.constraint(equalTo: gameModesContainer.bottomAnchor, constant: 20),
            feedbackContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            feedbackContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            feedbackLabel.topAnchor.constraint(equalTo: feedbackContainer.topAnchor, constant: 20),
            feedbackLabel.leadingAnchor.constraint(equalTo: feedbackContainer.leadingAnchor, constant: 20),
            
            feedbackText.topAnchor.constraint(equalTo: feedbackLabel.bottomAnchor, constant: 10),
            feedbackText.leadingAnchor.constraint(equalTo: feedbackContainer.leadingAnchor, constant: 20),
            feedbackText.trailingAnchor.constraint(equalTo: feedbackContainer.trailingAnchor, constant: -20),
            feedbackText.bottomAnchor.constraint(equalTo: feedbackContainer.bottomAnchor, constant: -20),
            
            // Version section
            versionContainer.topAnchor.constraint(equalTo: feedbackContainer.bottomAnchor, constant: 20),
            versionContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            versionContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            versionContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            versionLabel.topAnchor.constraint(equalTo: versionContainer.topAnchor, constant: 20),
            versionLabel.leadingAnchor.constraint(equalTo: versionContainer.leadingAnchor, constant: 20),
            
            versionText.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 10),
            versionText.leadingAnchor.constraint(equalTo: versionContainer.leadingAnchor, constant: 20),
            versionText.trailingAnchor.constraint(equalTo: versionContainer.trailingAnchor, constant: -20),
            versionText.bottomAnchor.constraint(equalTo: versionContainer.bottomAnchor, constant: -20)
        ])
    }
    
    private func createSectionContainer() -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.cardBackground
        container.layer.cornerRadius = 15
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
} 
