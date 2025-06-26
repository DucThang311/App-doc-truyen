//
//  DonateViewController.swift
//  StoryApp
//
//  Created by Mạc Đức Thắng on 18/6/25.
//

import UIKit

class DonateViewController: UIViewController {
    
    let imageDonate: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "QR")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        setUp()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
    }
    
    func setUp() {
        view.addSubview(imageDonate)
        
        NSLayoutConstraint.activate([
            imageDonate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageDonate.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func backTapped() {
        dismiss(animated: true, completion: nil)
    }

}
