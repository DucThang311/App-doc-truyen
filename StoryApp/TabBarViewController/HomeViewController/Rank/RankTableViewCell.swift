//
//  RankTableViewCell.swift
//  StoryApp
//
//  Created by Mạc Đức Thắng on 3/7/25.
//

import UIKit

class RankTableViewCell: UITableViewCell {
    
    private let rankLabel = UILabel()
    private let avatarContainer = UIView()
    private let avatarLabel = UILabel()
    private let usernameLabel = UILabel()
    private let roleLabel = UILabel()
    private let scoreLabel = UILabel()
    private let diamondImageView = UIImageView(image: UIImage(systemName: "diamond.fill"))
    
    private let verticalStack = UIStackView()
    private let horizontalStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .systemBackground

        // Rank Label
        rankLabel.font = .boldSystemFont(ofSize: 16)
        rankLabel.textColor = .label
        rankLabel.textAlignment = .center
        rankLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true

        // Avatar
        avatarLabel.font = .boldSystemFont(ofSize: 20)
        avatarLabel.textColor = .white
        avatarLabel.textAlignment = .center
        avatarLabel.clipsToBounds = true
        avatarLabel.layer.cornerRadius = 20
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        avatarLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        avatarContainer.addSubview(avatarLabel)
        avatarContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarLabel.centerXAnchor.constraint(equalTo: avatarContainer.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarContainer.centerYAnchor),
            avatarContainer.widthAnchor.constraint(equalToConstant: 50),
            avatarContainer.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Username & Role
        usernameLabel.font = .boldSystemFont(ofSize: 16)
        usernameLabel.textColor = .label
        
        roleLabel.font = .systemFont(ofSize: 14)
        roleLabel.textColor = .secondaryLabel

        verticalStack.axis = .vertical
        verticalStack.spacing = 2
        verticalStack.addArrangedSubview(usernameLabel)
        verticalStack.addArrangedSubview(roleLabel)
        
        // Score
        diamondImageView.tintColor = .systemBlue
        diamondImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        diamondImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        scoreLabel.font = .systemFont(ofSize: 14)
        scoreLabel.textColor = .label

        let scoreStack = UIStackView(arrangedSubviews: [scoreLabel, diamondImageView])
        scoreStack.axis = .horizontal
        scoreStack.spacing = 4
        scoreStack.alignment = .center

        // Horizontal Stack
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.spacing = 12
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalStack.addArrangedSubview(rankLabel)
        horizontalStack.addArrangedSubview(avatarContainer)
        horizontalStack.addArrangedSubview(verticalStack)
        horizontalStack.addArrangedSubview(UIView()) // Flexible space
        horizontalStack.addArrangedSubview(scoreStack)

        contentView.addSubview(horizontalStack)

        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with user: RankUser, rank: Int) {
        rankLabel.text = "\(user.rank)"
        usernameLabel.text = user.username
        roleLabel.text = user.role
        scoreLabel.text = "\(user.score)"
        
        if user.role == "Hunter Legend" {
            roleLabel.textColor = .systemRed
            avatarLabel.backgroundColor = .systemYellow
        } else {
            roleLabel.textColor = .secondaryLabel
            avatarLabel.backgroundColor = randomColor(for: user.username)
        }
        
        if let first = user.username.first {
            avatarLabel.text = String(first).uppercased()
        } else {
            avatarLabel.text = "?"
        }
        avatarLabel.backgroundColor = randomColor(for: user.username)
    }
    
    private func randomColor(for string: String) -> UIColor {
        let colors: [UIColor] = [.systemOrange, .systemPurple, .systemPink, .systemBlue, .systemGreen, .systemTeal, .systemYellow]
        let index = abs(string.hashValue) % colors.count
        return colors[index]
    }
}
