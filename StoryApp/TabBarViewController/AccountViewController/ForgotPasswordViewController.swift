//
//  ForgotPasswordViewController.swift
//  StoryReadingApp
//
//  Created by Mạc Đức Thắng on 10/6/25.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Image")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let emaiTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let forgotpasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Lấy lại mật khẩu", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        setupActions()
        
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
    }
    
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func backTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupLayout() {
        view.addSubview(logoImageView)
        view.addSubview(emaiTextField)
        view.addSubview(forgotpasswordButton)

        NSLayoutConstraint.activate([
            
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -50),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 300),
            logoImageView.heightAnchor.constraint(equalToConstant: 300),
            
            emaiTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: -50),
            emaiTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emaiTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            emaiTextField.heightAnchor.constraint(equalToConstant: 44),
            
            forgotpasswordButton.topAnchor.constraint(equalTo: emaiTextField.bottomAnchor, constant: 24),
            forgotpasswordButton.leadingAnchor.constraint(equalTo: emaiTextField.leadingAnchor),
            forgotpasswordButton.trailingAnchor.constraint(equalTo: emaiTextField.trailingAnchor),
            forgotpasswordButton.heightAnchor.constraint(equalToConstant: 48),

        ])
    }
    
    func setupActions() {
        forgotpasswordButton.addTarget(self, action: #selector(forgotpasswordTapped), for: .touchUpInside)
    }
    
    @objc func forgotpasswordTapped() {
        guard let email = emaiTextField.text, !email.isEmpty else {
            showAlert(message: "Vui lòng nhập email")
            return
        }

        // Giả lập gửi email
        showAlert(message: "Đã gửi liên kết khôi phục đến \(email)")
    }


}
