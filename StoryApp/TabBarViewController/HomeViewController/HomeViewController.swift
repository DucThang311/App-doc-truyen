//
//  HomeViewController.swift
//  StoryReadingApp
//
//  Created by Mạc Đức Thắng on 12/6/25.
//

import UIKit
import Alamofire
import AlamofireImage

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let searchBar = UISearchBar()
    var searchResults: [Comic] = []
    
    var allComics: [Comic] = []
    var comics: [Comic] = []

    let scrollView = UIScrollView()
    let contentStack = UIStackView()

    var carouselImages: [String] = []
    var timer: Timer?
    var currentIndex = 0
    
    let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 120, height: 180)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ComicCell.self, forCellWithReuseIdentifier: ComicCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.isHidden = true
        return collectionView
    }()

    let carouselCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()

    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = .black
        return pc
    }()

    var chineseComics: [Comic] = []
    var koreanComics: [Comic] = []
    var textComics: [Comic] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupScrollView()
        setupCarousel()
        setupCategoryButtons()
        fetchAllComicData()
        startAutoScroll()
    }

    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        scrollView.addSubview(contentStack)
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        searchBar.placeholder = "Tìm kiếm"
        searchBar.delegate = self
        contentStack.addArrangedSubview(searchBar)

        searchResultsCollectionView.dataSource = self
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(searchResultsCollectionView)
        searchResultsCollectionView.heightAnchor.constraint(equalToConstant: 400).isActive = true

    }

    func setupCarousel() {
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        carouselCollectionView.register(ComicCarouselCell.self, forCellWithReuseIdentifier: ComicCarouselCell.identifier)
        
        contentStack.addArrangedSubview(carouselCollectionView)
        carouselCollectionView.translatesAutoresizingMaskIntoConstraints = false
        carouselCollectionView.heightAnchor.constraint(equalToConstant: 350).isActive = true

        contentStack.addArrangedSubview(pageControl)
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    func setupCategoryButtons() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 8

        let buttons: [(String, String, Selector)] = [
            ("Image1", "Hot", #selector(didTapHot)),
            ("Image2", "Thể loại", #selector(didTapGenre))
//            ("Image3", "100 Chap+", #selector(didTap100Chaps)),
//            ("Image4", "Trọn bộ", #selector(didTapCompleted))
        ]

        for (imageName, title, selector) in buttons {
            let buttonView = createCategoryButton(imageName: imageName, title: title, action: selector)
            stack.addArrangedSubview(buttonView)
        }

        contentStack.addArrangedSubview(stack)
        stack.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }

    func setupContent() {
        contentStack.addArrangedSubview(createComicSection(title: "Truyện Trung Quốc", comics: chineseComics, tag: 1))
        contentStack.addArrangedSubview(createComicSection(title: "Truyện Hàn Quốc", comics: koreanComics, tag: 2))
        contentStack.addArrangedSubview(createComicSection(title: "Truyện chữ", comics: textComics, tag: 3))
    }

    func createComicSection(title: String, comics: [Comic], tag: Int) -> UIView {
        let sectionView = UIView()

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 180)
        layout.minimumLineSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.tag = tag
        collectionView.register(ComicCell.self, forCellWithReuseIdentifier: "ComicCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        sectionView.addSubview(titleLabel)
        sectionView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: sectionView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 180),
            collectionView.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor)
        ])

        collectionView.reloadData()
        return sectionView
    }

    func startAutoScroll() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { _ in
            guard !self.carouselImages.isEmpty else { return }
            let nextIndex = (self.currentIndex + 1) % self.carouselImages.count
            self.carouselCollectionView.scrollToItem(at: IndexPath(item: nextIndex, section: 0), at: .centeredHorizontally, animated: true)
            self.currentIndex = nextIndex
            self.pageControl.currentPage = nextIndex
        })
    }

    func createCategoryButton(imageName: String, title: String, action: Selector) -> UIView {
        let container = UIView()
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.addTarget(self, action: action, for: .touchUpInside)

        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stack)
        container.addSubview(button)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: container.centerYAnchor),

            button.topAnchor.constraint(equalTo: container.topAnchor),
            button.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        return container
    }

    @objc func didTapHot() {
        let vc = HotComicsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapGenre() {
        let vc = GenreFilterViewController()
        vc.comics = chineseComics + koreanComics + textComics
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func didTap100Chaps() { print("Lọc truyện > 100 chap") }
    @objc func didTapCompleted() { print("Hiển thị truyện đã hoàn thành") }

    func fetchAllComicData() {
        ComicService.shared.fetchComics { [weak self] response in
            guard let self = self, let data = response else { return }
            DispatchQueue.main.async {
                self.carouselImages = data.carouselImages
                self.chineseComics = data.chineseComics
                self.koreanComics = data.koreanComics
                self.textComics = data.textComics
                
                self.pageControl.numberOfPages = self.carouselImages.count
                self.carouselCollectionView.reloadData()
                self.setupContent()
            }
        }

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == carouselCollectionView {
            return carouselImages.count
        }
        
        if collectionView == searchResultsCollectionView {
            return searchResults.count
        }

        switch collectionView.tag {
        case 1: return chineseComics.count
        case 2: return koreanComics.count
        case 3: return textComics.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedComic: Comic?

        if collectionView == carouselCollectionView {
            return
        }
        
        if collectionView == searchResultsCollectionView {
            let comic = searchResults[indexPath.item]
            let detailVC = StoryDetailViewController()
            detailVC.comic = comic
            navigationController?.pushViewController(detailVC, animated: true)
            return
        }

        switch collectionView.tag {
        case 1:
            selectedComic = chineseComics[indexPath.item]
        case 2:
            selectedComic = koreanComics[indexPath.item]
        case 3:
            selectedComic = textComics[indexPath.item]
        default:
            selectedComic = nil
        }

        guard let comic = selectedComic else { return }

        let detailVC = StoryDetailViewController()
        detailVC.comic = selectedComic
        navigationController?.pushViewController(detailVC, animated: true)
        
//        let detailVC = StoryDetailViewController()
//        detailVC.comic = comic
//        detailVC.modalPresentationStyle = .fullScreen
//        present(detailVC, animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 1. Carousel
        if collectionView == carouselCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicCarouselCell.identifier, for: indexPath) as! ComicCarouselCell
            let imageName = carouselImages[indexPath.item]
            if let url = URL(string: imageName) {
                cell.imageView.af.setImage(withURL: url, placeholderImage: UIImage(systemName: "photo"))
            }
            return cell
        }
        
        // 2. Tìm kiếm
        if collectionView == searchResultsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicCell.identifier, for: indexPath) as! ComicCell
            let comic = searchResults[indexPath.item]
            cell.configure(with: comic)
            return cell
        }
        
        // 3. Truyện theo danh mục
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicCell.identifier, for: indexPath) as? ComicCell else {
            return UICollectionViewCell()
        }

        let comic: Comic
        switch collectionView.tag {
        case 1:
            comic = chineseComics[indexPath.item]
        case 2:
            comic = koreanComics[indexPath.item]
        case 3:
            comic = textComics[indexPath.item]
        default:
            return UICollectionViewCell()
        }

        cell.configure(with: comic)
        return cell
    }



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == carouselCollectionView {
            return collectionView.frame.size
        }
        return CGSize(width: 120, height: 180)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == carouselCollectionView {
            let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
            currentIndex = page
            pageControl.currentPage = page
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchResults = []
            searchResultsCollectionView.isHidden = true
            searchResultsCollectionView.reloadData()
            return
        }

        let allComics = chineseComics + koreanComics + textComics
        searchResults = allComics.filter { $0.title.lowercased().contains(searchText.lowercased()) }

        searchResultsCollectionView.isHidden = searchResults.isEmpty
        searchResultsCollectionView.reloadData()
        searchResultsCollectionView.backgroundColor = .systemBackground
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

