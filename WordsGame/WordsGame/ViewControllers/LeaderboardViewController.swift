import UIKit

class LeaderboardViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let backButton = UIButton()
    private let segmentedControl = UISegmentedControl(items: ["TIME MODE", "CHALLENGE MODE"])
    private let tableView = UITableView()
    
    private let scoreManager = ScoreManager()
    private var scores: [Score] = []
    private var selectedMode: GameMode = .time
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadScores()
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
        view.addBackgroundImage(named: "bg_leaderboard")
        
        // 应用渐变背景（应用在背景图片之上）
        view.applyGradient(colors: [
            UIColor(red: 21/255, green: 21/255, blue: 30/255, alpha: 1.0),
            UIColor(red: 40/255, green: 40/255, blue: 80/255, alpha: 1.0)
        ])
        
        // 设置头部
        setupHeader()
        
        // 设置分段控制器
        setupSegmentedControl()
        
        // 设置表格视图
        setupTableView()
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
        titleLabel.text = "LEADERBOARD"
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
    
    private func setupSegmentedControl() {
        // Style segmented control
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = UIColor.cardBackground
        segmentedControl.selectedSegmentTintColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        
        // Set text attributes
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(LeaderboardCell.self, forCellReuseIdentifier: "LeaderboardCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadScores() {
        scores = scoreManager.loadScores(forMode: selectedMode)
        
        if scores.isEmpty {
            tableView.backgroundView = createEmptyView()
        } else {
            tableView.backgroundView = nil
        }
        
        tableView.reloadData()
    }
    
    private func createEmptyView() -> UIView {
        let emptyView = UIView()
        
        let label = UILabel()
        label.text = "No scores yet. Play a game!"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        emptyView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor)
        ])
        
        return emptyView
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        SoundManager.shared.play(.click)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func segmentChanged() {
        SoundManager.shared.play(.click)
        selectedMode = segmentedControl.selectedSegmentIndex == 0 ? .time : .challenge
        loadScores()
    }
}

// MARK: - UITableViewDataSource
extension LeaderboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as? LeaderboardCell else {
            return UITableViewCell()
        }
        
        let score = scores[indexPath.row]
        cell.configure(rank: indexPath.row + 1, 
                       wordCount: score.wordCount, // 直接使用保存的单词数
                       score: score.score, // 直接使用总分
                       date: score.date)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LeaderboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

// MARK: - LeaderboardCell
class LeaderboardCell: UITableViewCell {
    
    private let rankLabel = UILabel()
    private let scoreLabel = UILabel()
    private let dateLabel = UILabel()
    private let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Container view
        containerView.backgroundColor = UIColor.cardBackground
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // Rank label
        rankLabel.textColor = .white
        rankLabel.font = UIFont.boldSystemFont(ofSize: 24)
        rankLabel.textAlignment = .center
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(rankLabel)
        
        // Score label
        scoreLabel.textColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 18)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(scoreLabel)
        
        // Date label
        dateLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            rankLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            rankLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            rankLabel.widthAnchor.constraint(equalToConstant: 40),
            
            scoreLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 16),
            scoreLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            scoreLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -50),
            
            dateLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 16),
            dateLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -50)
        ])
    }
    
    func configure(rank: Int, wordCount: Int, score: Int, date: Date) {
        rankLabel.text = "#\(rank)"
        scoreLabel.text = "\(wordCount) Words (\(score) Points)"
        
        // Format date - 使用更简洁的格式
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy HH:mm"
        dateLabel.text = formatter.string(from: date)
        
        // 先移除任何现有的奖牌图像视图，防止重叠
        containerView.subviews.forEach { view in
            if view is UIImageView {
                view.removeFromSuperview()
            }
        }
        
        // Add medal for top 3
        if rank <= 3 {
            let medalImage: UIImage?
            switch rank {
            case 1:
                medalImage = UIImage(systemName: "medal.fill")
                rankLabel.textColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1.0) // Gold
            case 2:
                medalImage = UIImage(systemName: "medal.fill")
                rankLabel.textColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0) // Silver
            case 3:
                medalImage = UIImage(systemName: "medal.fill")
                rankLabel.textColor = UIColor(red: 205/255, green: 127/255, blue: 50/255, alpha: 1.0) // Bronze
            default:
                medalImage = nil
                rankLabel.textColor = .white
            }
            
            if let image = medalImage {
                let medalImageView = UIImageView(image: image)
                medalImageView.tintColor = rankLabel.textColor
                medalImageView.translatesAutoresizingMaskIntoConstraints = false
                containerView.addSubview(medalImageView)
                
                NSLayoutConstraint.activate([
                    medalImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                    medalImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                    medalImageView.widthAnchor.constraint(equalToConstant: 30),
                    medalImageView.heightAnchor.constraint(equalToConstant: 30)
                ])
            }
        } else {
            rankLabel.textColor = .white
        }
    }
} 
