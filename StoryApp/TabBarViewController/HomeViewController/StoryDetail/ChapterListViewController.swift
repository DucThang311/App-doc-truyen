//
//  ChapterListViewController.swift
//  StoryApp
//
//  Created by Mạc Đức Thắng on 19/6/25.
//

import UIKit

class ChaptersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var comic: Comic?
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comic?.chapters?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chapter = comic?.chapters?[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = chapter?.title
        cell.detailTextLabel?.text = chapter?.isLocked == true ? "🔒" : "🆓"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let chapter = comic?.chapters?[indexPath.row] else { return }
        let readerVC = ChapterReaderViewController()
        readerVC.chapter = chapter
        navigationController?.pushViewController(readerVC, animated: true)
    }
}
