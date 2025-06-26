//
//  ComicCell.swift
//  StoryApp
//
//  Created by Mạc Đức Thắng on 12/6/25.
//

import UIKit
import AlamofireImage

class ComicCell: UICollectionViewCell {
    static let identifier = "ComicCell"

    let imageView = UIImageView()
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 10)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stack.axis = .vertical
        stack.spacing = 4

        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 4),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with comic: Comic) {
        titleLabel.text = comic.title
        if let url = URL(string: comic.imageURL) {
            imageView.af.setImage(withURL: url, placeholderImage: UIImage(systemName: "photo"))
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
    }
}
