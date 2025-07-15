//
//  RankViewController.swift
//  StoryApp
//
//  Created by Mạc Đức Thắng on 12/6/25.
//

import UIKit
import Alamofire

class RankViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView()
    private var rankedUsers: [RankUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Bảng xếp hạng"
        setupTableView()
        fetchRankData()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground 
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RankTableViewCell.self, forCellReuseIdentifier: "RankCell")
        tableView.separatorStyle = .none

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fetchRankData() {
        let url = "http://localhost:3000/api/discussions"

        AF.request(url).responseDecodable(of: [Discussion].self) { [weak self] response in
            switch response.result {
            case .success(let discussions):
                self?.processRankData(from: discussions)
            case .failure(let error):
                print("Lỗi tải dữ liệu BXH: \(error)")
            }
        }
    }

    private func processRankData(from discussions: [Discussion]) {
        var userCommentCounts: [String: Int] = [:]
        for discussion in discussions {
            let username = discussion.username
            userCommentCounts[username, default: 0] += 1
        }

        // Chuyển sang RankUser
        var tempUsers = userCommentCounts.map { RankUser(username: $0.key, commentCount: $0.value) }
        tempUsers.sort { $0.score > $1.score }

        // Tính rank đồng hạng
        rankedUsers = []
        var currentRank = 1
        var previousScore: Int? = nil
        var sameRankCount = 0

        for user in tempUsers {
            var newUser = user
            if let prev = previousScore, user.score == prev {
                sameRankCount += 1
            } else {
                currentRank += sameRankCount
                sameRankCount = 1
            }
            newUser.rank = currentRank

            // Gán "Hunter Legend" cho những người hạng 1
            if currentRank == 1 {
                newUser.role = "Hunter Legend"
            }

            rankedUsers.append(newUser)
            previousScore = user.score
        }

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - TableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankedUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RankCell", for: indexPath) as? RankTableViewCell else {
            return UITableViewCell()
        }
        let user = rankedUsers[indexPath.row]
        cell.configure(with: user, rank: indexPath.row + 1)
        return cell
    }

    // MARK: - TableView Delegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


