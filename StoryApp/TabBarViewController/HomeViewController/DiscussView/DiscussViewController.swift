//
//  DiscussViewController.swift
//  StoryApp
//
//  Created by Mạc Đức Thắng on 12/6/25.
//

import UIKit
import Alamofire

class DiscussViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var discussions: [Discussion] = []

    private let tableView = UITableView()
    private let messageTextField = UITextField()
    private let sendButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        title = "Thảo luận chung"

        setupUI()
        fetchDiscussions()
    }

    private func setupUI() {
        // TableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DiscussionTableViewCell.self, forCellReuseIdentifier: "DiscussionCell")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground

        view.addSubview(tableView)

        // Bottom Input View
        let inputContainer = UIView()
        inputContainer.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.backgroundColor = .secondarySystemBackground

        view.addSubview(inputContainer)

        messageTextField.placeholder = "Nhập bình luận..."
        messageTextField.borderStyle = .roundedRect
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        messageTextField.backgroundColor = .systemBackground

        sendButton.setTitle("Gửi", for: .normal)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false

        inputContainer.addSubview(messageTextField)
        inputContainer.addSubview(sendButton)

        NSLayoutConstraint.activate([
            // Table View
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainer.topAnchor),

            // Input Container
            inputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            inputContainer.heightAnchor.constraint(equalToConstant: 60),

            // Message TextField
            messageTextField.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 12),
            messageTextField.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            messageTextField.heightAnchor.constraint(equalToConstant: 40),

            // Send Button
            sendButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -12),
            sendButton.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func fetchDiscussions() {
        let url = "http://localhost:3000/api/discussions"
        AF.request(url).responseDecodable(of: [Discussion].self) { response in
            switch response.result {
            case .success(let data):
                self.discussions = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Lỗi tải thảo luận: \(error)")
            }
        }
    }

    @objc private func sendTapped() {
        guard let message = messageTextField.text, !message.isEmpty else {
            showAlert(message: "Vui lòng nhập nội dung")
            return
        }

        guard let token = UserDefaults.standard.string(forKey: "token") else {
            showAlert(message: "Bạn cần đăng nhập để gửi bình luận")
            return
        }

        let url = "http://localhost:3000/api/discussions"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let params = ["message": message]

        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: Discussion.self) { response in
                switch response.result {
                case .success(let newDiscussion):
                    self.discussions.insert(newDiscussion, at: 0)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.messageTextField.text = ""
                    }
                case .failure(let error):
                    print("Gửi bình luận thất bại: \(error)")
                    self.showAlert(message: "Không thể gửi bình luận. Vui lòng thử lại.")
                }
            }
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discussions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DiscussionCell", for: indexPath) as? DiscussionTableViewCell else {
            return UITableViewCell()
        }
        let discussion = discussions[indexPath.row]
        cell.configure(with: discussion)
        return cell
    }

    // MARK: - Alert Helper
    private func showAlert(title: String = "Thông báo", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
