//
//  ChapterReaderViewController.swift
//  StoryApp
//
//  Created by Mạc Đức Thắng on 13/6/25.
//

import UIKit
import AlamofireImage

class ChapterReaderViewController: UIViewController {
    var chapter: Chapter?

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = chapter?.title ?? "Đọc truyện"

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        loadImages()
    }

    private func loadImages() {
        guard let imageURLs = chapter?.images else { return }

        for urlStr in imageURLs {
            if let url = URL(string: urlStr) {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                imageView.af.setImage(withURL: url)
                stackView.addArrangedSubview(imageView)
            }
        }
    }
}
