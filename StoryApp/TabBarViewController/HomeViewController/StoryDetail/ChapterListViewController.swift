//
//  ChapterListViewController.swift
//  StoryApp
//
//  Created by Mạc Đức Thắng on 19/6/25.
//

import UIKit

protocol ChaptersViewControllerDelegate: AnyObject {
    func chaptersViewDidUpdateContentSize(_ size: CGSize)
}

class ChaptersViewController: UITableViewController {
    var comic: Comic? {
        didSet {
            tableView.reloadData()
            notifyContentSizeChanged()
        }
    }
    
    weak var delegate: ChaptersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Force update content size khi view xuất hiện
        notifyContentSizeChanged()
    }

    private func notifyContentSizeChanged() {
        DispatchQueue.main.async {
            self.tableView.layoutIfNeeded()
            let contentSize = self.tableView.contentSize
            self.delegate?.chaptersViewDidUpdateContentSize(contentSize)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comic?.chapters?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let chapter = comic?.chapters?[indexPath.row] else { return cell }
        
        var config = UIListContentConfiguration.valueCell()
        config.text = chapter.title
        config.secondaryText = chapter.isLocked ? "🔒" : "🆓"
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let chapter = comic?.chapters?[indexPath.row] else { return }
        let readerVC = ChapterReaderViewController()
        readerVC.chapter = chapter
        navigationController?.pushViewController(readerVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        notifyContentSizeChanged()
    }
    
    deinit {
        delegate = nil
    }
}
