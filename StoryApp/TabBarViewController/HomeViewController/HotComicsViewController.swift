//
//  HotComicsViewController.swift
//  StoryApp
//
//  Created by Mạc Đức Thắng on 17/6/25.
//

import UIKit

class HotComicsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var hotComics: [Comic] = []

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Truyện Hot"
        view.backgroundColor = .systemBackground

        setupCollectionView()
        loadHotComicsFromAPI()
    }

    private func setupCollectionView() {
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ComicCell.self, forCellWithReuseIdentifier: ComicCell.identifier)
        view.addSubview(collectionView)
    }

    private func loadHotComicsFromAPI() {
        ComicService.shared.fetchHotComics { [weak self] comics in
            guard let self = self else { return }

            self.hotComics = comics
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotComics.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let comic = hotComics[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicCell.identifier, for: indexPath) as! ComicCell
        cell.configure(with: comic)
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 30) / 2
        return CGSize(width: width, height: 250)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedComic = hotComics[indexPath.item]
        let detailVC = StoryDetailViewController()
        detailVC.comic = selectedComic
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
