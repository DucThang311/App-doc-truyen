//
//  FollowViewController.swift
//  StoryApp
//
//  Created by Mạc Đức Thắng on 12/6/25.
//

import UIKit

class FollowViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var favoriteComics: [Comic] = []
    private var collectionView: UICollectionView!
    
    private let loginNoticeLabel: UILabel = {
        let label = UILabel()
        label.text = "Vui lòng đăng nhập để xem "
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Tạo collectionView nhưng chưa add vào view
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 10, bottom: 16, right: 10)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ComicCell.self, forCellWithReuseIdentifier: ComicCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self

        loginNoticeLabel.frame = view.bounds
        view.addSubview(loginNoticeLabel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let token = UserDefaults.standard.string(forKey: "token")
        let isLoggedIn = !(token?.isEmpty ?? true)

        loginNoticeLabel.isHidden = isLoggedIn

        if isLoggedIn {
            if !collectionView.isDescendant(of: view) {
                collectionView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(collectionView)

                NSLayoutConstraint.activate([
                    collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
                ])
            }
            loadFavoriteComics()
        } else {
            favoriteComics = []
            collectionView.removeFromSuperview() 
        }
    }

    private func loadFavoriteComics() {
        let username = UserDefaults.standard.string(forKey: "username") ?? "guest"
        let key = "favoriteComics_\(username)"
        let favoriteIds = UserDefaults.standard.array(forKey: key) as? [Int] ?? []

        ComicService.shared.fetchComics { [weak self] response in
            guard let allComics = response else { return }
            let all = allComics.chineseComics + allComics.koreanComics + allComics.textComics
            self?.favoriteComics = all.filter { comic in
                guard let id = comic.id else { return false }
                return favoriteIds.contains(id)
            }
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }


    // MARK: - Collection View

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteComics.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicCell.identifier, for: indexPath) as! ComicCell
        cell.configure(with: favoriteComics[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = StoryDetailViewController()
        detailVC.comic = favoriteComics[indexPath.item]
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 20
        return CGSize(width: width, height: 200)
    }
}
