//
//  GenreFilterViewController.swift
//  StoryApp
//
//  Created by Mạc Đức Thắng on 14/6/25.
//

import UIKit

class GenreFilterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var comics: [Comic] = []           // Dữ liệu gốc
    var filteredComics: [Comic] = []   // Dữ liệu sau khi lọc
    var selectedGenre: String?         // Thể loại đang chọn

    let genres: [String] = [
        "Tất cả",
        "Hành động",
        "Phiêu lưu",
        "Esport",
        "Hài hước",
        "Phép thuật",
        "Học đường",
        "Hồi quy",
        "Fantasy",
        "Tình cảm",
        "Tiên hiệp",
        "Huyền huyễn",
        "Kiếm hiệp",
        "Ma pháp",
        "Dị giới"
    ]

    let genreScrollView = UIScrollView()
    let comicsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 16, height: 180)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(ComicCell.self, forCellWithReuseIdentifier: ComicCell.identifier)
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Thể loại truyện"
        setupGenreButtons()
        setupCollectionView()
        filterComics(by: nil) 
    }

    func setupGenreButtons() {
        genreScrollView.showsHorizontalScrollIndicator = false
        genreScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(genreScrollView)
        
        NSLayoutConstraint.activate([
            genreScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            genreScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            genreScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            genreScrollView.heightAnchor.constraint(equalToConstant: 50)
        ])

        var lastX: CGFloat = 16
        for genre in genres {
            let button = UIButton(type: .system)
            button.setTitle(genre, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .darkGray
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.layer.cornerRadius = 15
            button.clipsToBounds = true
            button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
            button.sizeToFit()
            button.frame = CGRect(x: lastX, y: 8, width: button.frame.width, height: 30)
            button.addTarget(self, action: #selector(genreTapped(_:)), for: .touchUpInside)
            genreScrollView.addSubview(button)
            lastX += button.frame.width + 10
        }

        genreScrollView.contentSize = CGSize(width: lastX, height: 50)
    }

    func setupCollectionView() {
        view.addSubview(comicsCollectionView)
        comicsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        comicsCollectionView.dataSource = self
        comicsCollectionView.delegate = self

        NSLayoutConstraint.activate([
            comicsCollectionView.topAnchor.constraint(equalTo: genreScrollView.bottomAnchor),
            comicsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            comicsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            comicsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc func genreTapped(_ sender: UIButton) {
        let genre = sender.titleLabel?.text
        selectedGenre = genre == "Tất cả" ? nil : genre
        filterComics(by: selectedGenre)
    }

    func filterComics(by genre: String?) {
        if let genre = genre {
            filteredComics = comics.filter { $0.genres?.contains(genre) == true }
        } else {
            filteredComics = comics
        }
        comicsCollectionView.reloadData()
    }

    // MARK: - Collection View

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredComics.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let comic = filteredComics[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicCell.identifier, for: indexPath) as! ComicCell
        cell.configure(with: comic)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comic = filteredComics[indexPath.item]
        let detailVC = StoryDetailViewController()
        detailVC.comic = comic
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

