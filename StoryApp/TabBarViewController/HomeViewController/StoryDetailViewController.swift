import UIKit
import AlamofireImage

class StoryDetailViewController: UIViewController {
    var comic: Comic?
    
    // UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let coverImageView = UIImageView()
    private let titleLabel = UILabel()
    private let genreContainerView = UIView()
    private var genreViews: [UIView] = []
    private let statusLabel = UILabel()
    private let updatedLabel = UILabel()
    private let viewsLabel = UILabel()
    private let followsLabel = UILabel()
    private let tabStackView = UIStackView()
    private let introButton = UIButton(type: .system)
    private let chaptersButton = UIButton(type: .system)
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private var pageViewControllerHeightConstraint: NSLayoutConstraint?
    private let actionStack = UIStackView()
    private let favoriteButton = UIButton(type: .system)
    private let readButton = UIButton(type: .system)
    
    // View Controllers
    private lazy var introVC: IntroViewController = {
        let vc = IntroViewController()
        vc.delegate = self
        return vc
    }()
    
    private lazy var chaptersVC: ChaptersViewController = {
        let vc = ChaptersViewController()
        vc.delegate = self
        return vc
    }()
    
    // State
    private enum TabType { case intro, chapters }
    private var currentTab: TabType = .intro
    private var lastContentHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Chi tiết truyện"
        setupPageViewController()
        setupUI()
        configureWithComic()
        updatePageHeight(for: introVC)
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }
    
    private func setupPageViewController() {
        pageViewController.dataSource = self
        addChild(pageViewController)
        contentView.addSubview(pageViewController.view)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.didMove(toParent: self)
        pageViewController.setViewControllers([introVC], direction: .forward, animated: false)
        
        pageViewControllerHeightConstraint = pageViewController.view.heightAnchor.constraint(equalToConstant: 100)
        pageViewControllerHeightConstraint?.isActive = true
    }
    
    @objc private func tabTapped(_ sender: UIButton) {
        let isIntro = sender == introButton
        currentTab = isIntro ? .intro : .chapters
        
        let nextVC = isIntro ? introVC : chaptersVC
        let direction: UIPageViewController.NavigationDirection = isIntro ? .reverse : .forward
        
        pageViewController.setViewControllers([nextVC], direction: direction, animated: true) { _ in
            self.updatePageHeight(for: nextVC)
        }
        
        updateTabUI(index: isIntro ? 0 : 1)
    }
    
    private func updateTabUI(index: Int) {
        let buttons = [introButton, chaptersButton]
        for (i, btn) in buttons.enumerated() {
            btn.backgroundColor = i == index ? .gray : .white
            btn.setTitleColor(i == index ? .white : .black, for: .normal)
        }
    }
    
    private func updatePageHeight(for vc: UIViewController) {
        DispatchQueue.main.async {
            var newHeight: CGFloat = 0
            
            switch self.currentTab {
            case .intro:
                self.introVC.view.layoutIfNeeded()
                newHeight = self.introVC.view.systemLayoutSizeFitting(
                    CGSize(width: self.view.bounds.width - 32, height: UIView.layoutFittingCompressedSize.height),
                    withHorizontalFittingPriority: .required,
                    verticalFittingPriority: .fittingSizeLevel
                ).height + 40
                
            case .chapters:
                self.chaptersVC.tableView.layoutIfNeeded()
                newHeight = self.chaptersVC.tableView.contentSize.height
                
                // Thêm padding và chiều cao tối thiểu
                let minHeight = self.view.bounds.height * 0.6
                let maxHeight = self.view.bounds.height * 1.5
                newHeight = min(max(newHeight, minHeight), maxHeight)
            }
            
            UIView.animate(withDuration: 0.3) {
                self.pageViewControllerHeightConstraint?.constant = newHeight
                self.view.layoutIfNeeded()
            }
        }
    }
    
    deinit {
        pageViewController.dataSource = nil
    }
}

// MARK: - UIPageViewControllerDataSource
extension StoryDetailViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        viewController is ChaptersViewController ? introVC : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        viewController is IntroViewController ? chaptersVC : nil
    }
}

// MARK: - IntroViewControllerDelegate
extension StoryDetailViewController: IntroViewControllerDelegate {
    func introViewDidUpdateHeight(_ height: CGFloat) {
        guard currentTab == .intro else { return }
        updatePageHeight(for: introVC)
    }
}

// MARK: - ChaptersViewControllerDelegate
extension StoryDetailViewController: ChaptersViewControllerDelegate {
    func chaptersViewDidUpdateContentSize(_ size: CGSize) {
        guard currentTab == .chapters else { return }
        updatePageHeight(for: chaptersVC)
    }
}

// MARK: - UI Setup
extension StoryDetailViewController {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupCoverImageAndTitle()
        setupGenreContainer()
        setupInfoLabels()
        setupTabButtons()
        setupPageViewControllerConstraints()
        setupActionButtons()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
    
    private func setupCoverImageAndTitle() {
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.layer.cornerRadius = 8
        coverImageView.clipsToBounds = true
        
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coverImageView.widthAnchor.constraint(equalToConstant: 100),
            coverImageView.heightAnchor.constraint(equalToConstant: 140),
            
            titleLabel.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupGenreContainer() {
        genreContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(genreContainerView)
        
        NSLayoutConstraint.activate([
            genreContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            genreContainerView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genreContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupInfoLabels() {
        [statusLabel, updatedLabel, viewsLabel, followsLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = .systemFont(ofSize: 14)
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: genreContainerView.bottomAnchor, constant: 16),
            statusLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            updatedLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 4),
            updatedLabel.leadingAnchor.constraint(equalTo: statusLabel.leadingAnchor),
            
            viewsLabel.topAnchor.constraint(equalTo: updatedLabel.bottomAnchor, constant: 4),
            viewsLabel.leadingAnchor.constraint(equalTo: statusLabel.leadingAnchor),
            
            followsLabel.topAnchor.constraint(equalTo: viewsLabel.bottomAnchor, constant: 4),
            followsLabel.leadingAnchor.constraint(equalTo: statusLabel.leadingAnchor)
        ])
    }
    
    private func setupTabButtons() {
        introButton.setTitle("GIỚI THIỆU", for: .normal)
        chaptersButton.setTitle("CHAP", for: .normal)
        
        [introButton, chaptersButton].forEach {
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            $0.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
        }
        
        // Set initial selected tab
        introButton.backgroundColor = .gray
        introButton.setTitleColor(.white, for: .normal)
        
        tabStackView.axis = .horizontal
        tabStackView.distribution = .fillEqually
        tabStackView.spacing = 10
        tabStackView.translatesAutoresizingMaskIntoConstraints = false
        tabStackView.addArrangedSubview(introButton)
        tabStackView.addArrangedSubview(chaptersButton)
        contentView.addSubview(tabStackView)
        
        NSLayoutConstraint.activate([
            tabStackView.topAnchor.constraint(equalTo: followsLabel.bottomAnchor, constant: 16),
            tabStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tabStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tabStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupPageViewControllerConstraints() {
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: tabStackView.bottomAnchor, constant: 8),
            pageViewController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -80)
        ])
    }
    
    private func setupActionButtons() {
        favoriteButton.setTitle("Yêu thích", for: .normal)
        favoriteButton.backgroundColor = .systemRed
        favoriteButton.setTitleColor(.white, for: .normal)
        favoriteButton.layer.cornerRadius = 8
        favoriteButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        
        readButton.setTitle("Bắt đầu đọc", for: .normal)
        readButton.backgroundColor = .systemBlue
        readButton.setTitleColor(.white, for: .normal)
        readButton.layer.cornerRadius = 8
        readButton.addTarget(self, action: #selector(startReading), for: .touchUpInside)
        
        actionStack.axis = .horizontal
        actionStack.spacing = 12
        actionStack.distribution = .fillEqually
        actionStack.translatesAutoresizingMaskIntoConstraints = false
        actionStack.addArrangedSubview(favoriteButton)
        actionStack.addArrangedSubview(readButton)
        view.addSubview(actionStack)
        
        NSLayoutConstraint.activate([
            actionStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            actionStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            actionStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            actionStack.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

// MARK: - Data Configuration
extension StoryDetailViewController {
    private func configureWithComic() {
        guard let comic = comic else { return }
        
        if let url = URL(string: comic.imageURL) {
            coverImageView.af.setImage(withURL: url)
        }
        
        titleLabel.text = comic.title
        
        if let genres = comic.genres?.components(separatedBy: ",") {
            layoutGenres(genres: genres)
        }
        
        statusLabel.text = "Tình trạng: \(comic.status ?? "")"
        updatedLabel.text = "Cập nhật: \(comic.updatedAt ?? "")"
        viewsLabel.text = "Lượt xem: \(comic.views ?? 0)"
        followsLabel.text = "Lượt theo dõi: \(comic.followers ?? 0)"
        
        introVC.comic = comic
        chaptersVC.comic = comic
    }
    
    private func layoutGenres(genres: [String]) {
        genreViews.forEach { $0.removeFromSuperview() }
        genreViews = []
        
        let spacingX: CGFloat = 8
        let spacingY: CGFloat = 8
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        let maxWidth = view.frame.width - 150
        
        for genre in genres {
            let label = UILabel()
            label.text = genre.trimmingCharacters(in: .whitespaces)
            label.font = .systemFont(ofSize: 13)
            label.textColor = .systemBlue
            label.textAlignment = .center
            
            let container = UIView()
            container.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
            container.layer.cornerRadius = 12
            container.layer.borderWidth = 1
            container.layer.borderColor = UIColor.systemBlue.cgColor
            container.clipsToBounds = true
            
            label.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(label)
            genreContainerView.addSubview(container)
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
                label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4),
                label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
                label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8)
            ])
            
            let size = container.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            if currentX + size.width > maxWidth {
                currentX = 0
                currentY += size.height + spacingY
            }
            
            container.frame = CGRect(x: currentX, y: currentY, width: size.width, height: size.height)
            currentX += size.width + spacingX
            genreViews.append(container)
        }
        
        let totalHeight = currentY + (genreViews.last?.frame.height ?? 0)
        genreContainerView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
    }
}

// MARK: - Action Handlers
extension StoryDetailViewController {
    @objc private func addToFavorite() {
        guard let comic = comic else { return }
        
        // Check login
        let token = UserDefaults.standard.string(forKey: "token")
        let username = UserDefaults.standard.string(forKey: "username") ?? "guest"
        let isLoggedIn = !(token?.isEmpty ?? true)
        
        guard isLoggedIn else {
            showAlert(message: "Vui lòng đăng nhập để sử dụng chức năng này.")
            return
        }
        
        let key = "favoriteComics_\(username)"
        var favorites = UserDefaults.standard.array(forKey: key) as? [Int] ?? []
        
        if let id = comic.id {
            if favorites.contains(id) {
                favorites.removeAll { $0 == id }
                showAlert(message: "Đã xóa khỏi danh sách yêu thích.")
                favoriteButton.tintColor = .lightGray
            } else {
                favorites.append(id)
                showAlert(message: "Đã thêm vào danh sách yêu thích.")
                favoriteButton.tintColor = .systemRed
            }
            UserDefaults.standard.set(favorites, forKey: key)
        }
    }
    
    @objc private func startReading() {
        guard let chapter = comic?.chapters?.first else {
            showAlert(message: "Không có chapter nào!")
            return
        }
        let readerVC = ChapterReaderViewController()
        readerVC.chapter = chapter
        navigationController?.pushViewController(readerVC, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIPageViewControllerDelegate
extension StoryDetailViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
              let currentVC = pageViewController.viewControllers?.first else { return }
        
        // Cập nhật tab hiện tại
        currentTab = currentVC is IntroViewController ? .intro : .chapters
        updateTabUI(index: currentTab == .intro ? 0 : 1)
        updatePageHeight(for: currentVC)
    }
}
