//
//  IntroViewController.swift
//  StoryApp
//
//  Created by Mạc Đức Thắng on 19/6/25.
//

import UIKit

class IntroViewController: UIViewController {
    var comic: Comic?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Setup scroll view để xử lý nội dung dài
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Label mô tả
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 15)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = comic?.description ?? "Không có mô tả"
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8), // Giảm khoảng cách phía trên
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Description Label
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0), // Sát lên trên
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
