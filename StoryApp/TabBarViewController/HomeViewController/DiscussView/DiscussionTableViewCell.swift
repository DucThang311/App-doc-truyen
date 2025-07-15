//
//  DiscussionTableViewCell.swift
//  StoryApp
//
//  Created by Mạc Đức Thắng on 1/7/25.
//

import UIKit

class DiscussionTableViewCell: UITableViewCell {
    private let avatarContainer = UIView()
    private let frameImageView = UIImageView()
    let avatarLabel = UILabel()
    let usernameLabel = UILabel()
    let dateLabel = UILabel()
    let messageLabel = UILabel()
    private let verticalStack = UIStackView()
    private let horizontalStack = UIStackView()
    private let horizontalTopStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI() {
        selectionStyle = .none

        frameImageView.contentMode = .scaleAspectFit
        frameImageView.translatesAutoresizingMaskIntoConstraints = false
        frameImageView.isHidden = true

        avatarLabel.textAlignment = .center
        avatarLabel.textColor = .white
        avatarLabel.font = UIFont.boldSystemFont(ofSize: 20)
        avatarLabel.clipsToBounds = true
        avatarLabel.layer.cornerRadius = 15
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        avatarLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        avatarContainer.translatesAutoresizingMaskIntoConstraints = false
        avatarContainer.addSubview(frameImageView)
        avatarContainer.addSubview(avatarLabel)

        NSLayoutConstraint.activate([
            frameImageView.topAnchor.constraint(equalTo: avatarContainer.topAnchor),
            frameImageView.leadingAnchor.constraint(equalTo: avatarContainer.leadingAnchor),
            frameImageView.trailingAnchor.constraint(equalTo: avatarContainer.trailingAnchor),
            frameImageView.bottomAnchor.constraint(equalTo: avatarContainer.bottomAnchor),
            avatarLabel.centerXAnchor.constraint(equalTo: avatarContainer.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarContainer.centerYAnchor),
            avatarContainer.widthAnchor.constraint(equalToConstant: 50),
            avatarContainer.heightAnchor.constraint(equalToConstant: 50)
        ])

        usernameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        usernameLabel.textColor = .label
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .secondaryLabel
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .label

        horizontalTopStack.axis = .horizontal
        horizontalTopStack.alignment = .center
        horizontalTopStack.distribution = .equalSpacing
        horizontalTopStack.addArrangedSubview(usernameLabel)
        horizontalTopStack.addArrangedSubview(dateLabel)

        verticalStack.axis = .vertical
        verticalStack.spacing = 4
        verticalStack.addArrangedSubview(horizontalTopStack)
        verticalStack.addArrangedSubview(messageLabel)

        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 12
        horizontalStack.alignment = .top
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.addArrangedSubview(avatarContainer)
        horizontalStack.addArrangedSubview(verticalStack)

        contentView.addSubview(horizontalStack)

        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with discussion: Discussion) {
        usernameLabel.text = discussion.username
        messageLabel.text = discussion.message

        if let first = discussion.username.first {
            avatarLabel.text = String(first).uppercased()
        } else {
            avatarLabel.text = "?"
        }

        if discussion.username.lowercased() == "admin" {
            frameImageView.image = UIImage(named: "admin_frame")
            frameImageView.isHidden = false
            avatarLabel.backgroundColor = .systemYellow
            avatarLabel.textColor = .black
            avatarLabel.layer.borderWidth = 0
        } else {
            frameImageView.isHidden = true
            avatarLabel.backgroundColor = randomColor(for: discussion.username)
            avatarLabel.textColor = .white
            avatarLabel.layer.borderWidth = 0
        }

        dateLabel.text = formattedDate(from: discussion.createdAt)
    }

    private func formattedDate(from isoDate: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = isoFormatter.date(from: isoDate) else { return isoDate }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = Locale(identifier: "vi_VN")
        return formatter.string(from: date)
    }


    private func randomColor(for string: String) -> UIColor {
        let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemOrange, .systemPurple, .systemTeal, .systemFill, .systemPink , .systemBrown, .systemCyan , .systemMint]
        let index = abs(string.hashValue) % colors.count
        return colors[index]
    }
}
