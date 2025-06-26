//
//  LoginViewController.swift
//  StoryReadingApp
//
//  Created by Mạc Đức Thắng on 10/6/25.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
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

    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Đăng nhập", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Đăng ký", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Quên mật khẩu", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(forgotPasswordButton)

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

            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            loginButton.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 48),

            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 12),
            registerButton.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),

            forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 12),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor)
        ])
    }

    func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
    }

    @objc func loginTapped() {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Vui lòng nhập đủ thông tin")
            return
        }

        let params = ["username": username, "password": password]
        let url = "http://localhost:3000/api/auth/login"

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let data):
                    // LƯU TOKEN và username
                    UserDefaults.standard.setValue(data.token, forKey: "token")
                    UserDefaults.standard.set(username, forKey: "username")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.synchronize()

                    self.showAlert(message: "Đăng nhập thành công") {
                        self.dismiss(animated: true)
                    }
                case .failure:
                    self.showAlert(message: "Tài khoản hoặc mật khẩu không đúng")
                }
            }
    }

    struct LoginResponse: Codable {
        let token: String
    }

    @objc func registerTapped() {
        let registerVC = RegisterViewController()
        registerVC.modalPresentationStyle = .fullScreen
        present(registerVC, animated: true, completion: nil)
    }

    @objc func forgotPasswordTapped() {
        let forgotPasswordVC = ForgotPasswordViewController()
        forgotPasswordVC.modalPresentationStyle = .fullScreen
        present(forgotPasswordVC, animated: true, completion: nil)
    }
}
