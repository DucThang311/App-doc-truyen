//
//  IntroViewController.swift
//  StoryApp
//
//  Created by Mạc Đức Thắng on 19/6/25.
//

import UIKit

protocol IntroViewControllerDelegate: AnyObject {
    func introViewDidUpdateHeight(_ height: CGFloat)
}

class IntroViewController: UIViewController {
    let contentLabel = UILabel()
    weak var delegate: IntroViewControllerDelegate?
    
    var comic: Comic? {
        didSet {
            updateContent()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            contentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Force update height khi view xuất hiện
        updateContent()
    }

    private func updateContent() {
        contentLabel.text = comic?.description
        view.layoutIfNeeded()
        
        let newHeight = view.systemLayoutSizeFitting(
            CGSize(width: view.bounds.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
        
        delegate?.introViewDidUpdateHeight(newHeight)
        
    }
    
    deinit {
        delegate = nil
    }
}
