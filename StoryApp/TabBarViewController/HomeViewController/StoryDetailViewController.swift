import UIKit
import AlamofireImage

class StoryDetailViewController: UIViewController {
    var comic: Comic?

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

    private let horizontalScrollView = UIScrollView()
    private let introView = IntroView()
    private let chaptersView = ChaptersView()

    private let actionStack = UIStackView()
    private let favoriteButton = UIButton(type: .system)
    private let readButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithComic()
    }

    private func setupUI() {
        view.backgroundColor = .white

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
//        scrollView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 100, right: 0)
        
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

        // Cover + title
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

        // Thể loại
        genreContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(genreContainerView)

        NSLayoutConstraint.activate([
            genreContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            genreContainerView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genreContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])

        // Info labels
        [statusLabel, updatedLabel, viewsLabel, followsLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
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

        // Tabs
        introButton.setTitle("GIỚI THIỆU", for: .normal)
        chaptersButton.setTitle("CHAP", for: .normal)

        [introButton, chaptersButton].forEach {
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            $0.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
        }

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

        // Horizontal scroll view
        horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
        horizontalScrollView.isPagingEnabled = true
        horizontalScrollView.showsHorizontalScrollIndicator = false
        
        contentView.addSubview(horizontalScrollView)

        NSLayoutConstraint.activate([
            horizontalScrollView.topAnchor.constraint(equalTo: tabStackView.bottomAnchor, constant: 8),
            horizontalScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalScrollView.heightAnchor.constraint(equalToConstant: 400),
            horizontalScrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -80)
        ])

        // Add intro + chap views
        introView.translatesAutoresizingMaskIntoConstraints = false
        chaptersView.translatesAutoresizingMaskIntoConstraints = false
        horizontalScrollView.addSubview(introView)
        horizontalScrollView.addSubview(chaptersView)

        NSLayoutConstraint.activate([
            introView.leadingAnchor.constraint(equalTo: horizontalScrollView.leadingAnchor),
            introView.topAnchor.constraint(equalTo: horizontalScrollView.topAnchor),
            introView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            introView.bottomAnchor.constraint(equalTo: horizontalScrollView.bottomAnchor),

            chaptersView.leadingAnchor.constraint(equalTo: introView.trailingAnchor),
            chaptersView.topAnchor.constraint(equalTo: horizontalScrollView.topAnchor),
            chaptersView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            chaptersView.bottomAnchor.constraint(equalTo: horizontalScrollView.bottomAnchor),

            chaptersView.trailingAnchor.constraint(equalTo: horizontalScrollView.trailingAnchor)
        ])

        // Bottom action buttons
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

    @objc private func tabTapped(_ sender: UIButton) {
        let page = sender == introButton ? 0 : 1
        let offset = CGFloat(page) * scrollView.bounds.width
        horizontalScrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        updateTabUI(index: page)
    }

    private func updateTabUI(index: Int) {
        let buttons = [introButton, chaptersButton]
        for (i, btn) in buttons.enumerated() {
            btn.backgroundColor = (i == index) ? .gray : .white
            btn.setTitleColor(i == index ? .white : .black, for: .normal)
        }
    }

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

        introView.comic = comic
        chaptersView.comic = comic
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
            label.text = genre
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

    @objc func addToFavorite() {
        guard let comic = comic else { return }
        let token = UserDefaults.standard.string(forKey: "token")
        let username = UserDefaults.standard.string(forKey: "username") ?? "guest"
        let key = "favoriteComics_\(username)"
        var favorites = UserDefaults.standard.array(forKey: key) as? [Int] ?? []

        if let id = comic.id {
            if favorites.contains(id) {
                favorites.removeAll { $0 == id }
                favoriteButton.tintColor = .lightGray
                showAlert(message: "Đã xóa khỏi danh sách yêu thích.")
            } else {
                favorites.append(id)
                favoriteButton.tintColor = .systemRed
                showAlert(message: "Đã thêm vào danh sách yêu thích.")
            }
            UserDefaults.standard.set(favorites, forKey: key)
        }
    }

    @objc func startReading() {
        guard let chapter = comic?.chapters?.first else {
            showAlert(message: "Không có chapter nào!")
            return
        }
        let readerVC = ChapterReaderViewController()
        readerVC.chapter = chapter
        navigationController?.pushViewController(readerVC, animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

class IntroView: UIView {
    var comic: Comic? {
        didSet { label.text = comic?.description ?? "Không có nội dung" }
    }
    private let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

class ChaptersView: UIView, UITableViewDataSource, UITableViewDelegate {
    var comic: Comic? {
        didSet {
            tableView.reloadData()
            tableView.layoutIfNeeded()
        }
    }
    private let tableView = UITableView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comic?.chapters?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let chapter = comic?.chapters?[indexPath.row] else { return cell }
        var config = UIListContentConfiguration.valueCell()
        config.text = chapter.title
        config.secondaryText = chapter.isLocked ? "🔒" : "🆓"
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let chapter = comic?.chapters?[indexPath.row] else { return }
        let readerVC = ChapterReaderViewController()
        readerVC.chapter = chapter
        UIApplication.shared.keyWindow?.rootViewController?.present(readerVC, animated: true)
    }
}
