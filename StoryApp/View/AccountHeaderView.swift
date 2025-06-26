//
//  AccountHeaderView.swift
//  StoryReadingApp
//
//  Created by Mạc Đức Thắng on 10/6/25.
//

import UIKit

class AccountHeaderView: UIView {
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        avatarImageView.tintColor = .gray
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true

        nameLabel.font = .boldSystemFont(ofSize: 18)
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .gray

        let textStack = UIStackView(arrangedSubviews: [nameLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 2

        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.addArrangedSubview(avatarImageView)
        stackView.addArrangedSubview(textStack)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    func configure(username: String, subtitle: String) {
        nameLabel.text = username
        subtitleLabel.text = subtitle
    }

    // Tính chiều cao phù hợp
    func fittingSize(width: CGFloat) -> CGSize {
        let targetSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        return systemLayoutSizeFitting(targetSize,
                                       withHorizontalFittingPriority: .required,
                                       verticalFittingPriority: .fittingSizeLevel)
    }
}
