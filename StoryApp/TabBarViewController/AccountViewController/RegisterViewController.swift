//
//  RegisterViewController.swift
//  StoryReadingApp
//
//  Created by Mạc Đức Thắng on 10/6/25.
//

import UIKit

class RegisterViewController: UIViewController {
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Image")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Truyện Hay"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Tên tài khoản"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Mật khẩu"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let confirmPasswordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Nhập lại mật khẩu"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emaiTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let termsCheckBox = UIButton(type: .custom)
    let termsLabel = UILabel()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Đăng ký", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var isChecked = false

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
        view.addSubview(titleLabel)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordField)
        view.addSubview(emaiTextField)
        view.addSubview(registerButton)

        termsCheckBox.translatesAutoresizingMaskIntoConstraints = false
        termsCheckBox.setImage(UIImage(systemName: "square"), for: .normal)
        termsCheckBox.tintColor = .darkGray
        termsCheckBox.addTarget(self, action: #selector(toggleCheck), for: .touchUpInside)
        
        let termsTextLabel = UILabel()
        termsTextLabel.text = "Tôi đồng ý với "
        termsTextLabel.font = .systemFont(ofSize: 14)
        termsTextLabel.textColor = .black

        let termLink = UIButton(type: .system)
        termLink.setTitle("Điều khoản dịch vụ", for: .normal)
        termLink.titleLabel?.font = .systemFont(ofSize: 14)
        termLink.setTitleColor(.systemBlue, for: .normal)
        termLink.addTarget(self, action: #selector(openTerms), for: .touchUpInside)

        let termsLabelStack = UIStackView(arrangedSubviews: [termsTextLabel, termLink])
        termsLabelStack.axis = .horizontal
        termsLabelStack.spacing = 2
        termsLabelStack.alignment = .center
        termsLabelStack.translatesAutoresizingMaskIntoConstraints = false

        let termsStack = UIStackView(arrangedSubviews: [termsCheckBox, termsLabelStack])
        termsStack.axis = .horizontal
        termsStack.spacing = 8
        termsStack.alignment = .center
        termsStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(termsStack)
        
        NSLayoutConstraint.activate([
            
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -50),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 300),
            logoImageView.heightAnchor.constraint(equalToConstant: 300),

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: -50),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            usernameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            usernameTextField.heightAnchor.constraint(equalToConstant: 44),

            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            confirmPasswordField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            confirmPasswordField.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            confirmPasswordField.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            confirmPasswordField.heightAnchor.constraint(equalToConstant: 44),
                                                         
            emaiTextField.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: 16),
            emaiTextField.leadingAnchor.constraint(equalTo: confirmPasswordField.leadingAnchor),
            emaiTextField.trailingAnchor.constraint(equalTo: confirmPasswordField.trailingAnchor),
            emaiTextField.heightAnchor.constraint(equalToConstant: 44),
            
            termsStack.topAnchor.constraint(equalTo: emaiTextField.bottomAnchor, constant: 20),
            termsStack.leadingAnchor.constraint(equalTo: emaiTextField.leadingAnchor),
            termsStack.trailingAnchor.constraint(lessThanOrEqualTo: emaiTextField.trailingAnchor),

            termsCheckBox.widthAnchor.constraint(equalToConstant: 20),
            termsCheckBox.heightAnchor.constraint(equalToConstant: 20),

            registerButton.topAnchor.constraint(equalTo: termsStack.bottomAnchor, constant: 24),
            registerButton.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            registerButton.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 48),
            
        ])
    }
    
    func setupActions() {
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
    }
    
    @objc func registerTapped() {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirm = confirmPasswordField.text, password == confirm else {
            showAlert(message: "Vui lòng nhập đúng thông tin và xác nhận mật khẩu")
            return
        }

        if !isChecked {
            showAlert(message: "Bạn cần đồng ý với điều khoản")
            return
        }

        AuthService.shared.register(username: username, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let msg):
                    self.showAlert(message: "\(msg)", completion: {
                        self.dismiss(animated: true)
                    })
                case .failure:
                    self.showAlert(message: "Đăng ký thất bại. Tài khoản có thể đã tồn tại.")
                }
            }
        }
    }

    
    @objc func toggleCheck() {
        isChecked.toggle()
        let imageName = isChecked ? "checkmark.square.fill" : "square"
        termsCheckBox.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc func openTerms() {
        let termsofServiveVC = TermsofServiceViewController()
        termsofServiveVC.modalPresentationStyle = .fullScreen
        present(termsofServiveVC, animated: true, completion: nil)
    }
    

}
