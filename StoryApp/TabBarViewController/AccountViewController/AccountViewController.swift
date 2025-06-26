//
//  AccountViewController.swift
//  StoryReadingApp
//
//  Created by Mạc Đức Thắng on 10/6/25.
//

import UIKit

class AccountViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    private var headerView = AccountHeaderView()

    private var sections: [(title: String, items: [AccountItem])] {
        var baseSections: [(String, [AccountItem])] = [
            ("Chức năng thành viên", [
                AccountItem(icon: "arrow.right.circle", title: "Đăng nhập"),
                AccountItem(icon: "square.grid.2x2", title: "Đăng ký"),
                AccountItem(icon: "bell", title: "Thông báo")
            ]),
            ("Cài đặt", [
                AccountItem(icon: "dollarsign.circle", title: "Donate"),
                AccountItem(icon: "moon.fill", title: "Chế độ nền tối", isToggle: true, isOn: false)
            ]),
            ("Hỗ trợ người dùng", [
                AccountItem(icon: "shield.fill", title: "Điều khoản sử dụng")
            ])
        ]

        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            baseSections.insert(("Tài khoản", [
                AccountItem(icon: "rectangle.portrait.and.arrow.right", title: "Đăng xuất")
            ]), at: 3)
        }

        return baseSections
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        let username = UserDefaults.standard.string(forKey: "username")

        if isLoggedIn, let name = username {
            headerView.configure(username: name, subtitle: "Đạo sĩ - Trường phái Cổ Mộ")
        } else {
            headerView.configure(username: "Khách thập phương", subtitle: "Giang Hồ Võ Giả")
        }

        let size = headerView.fittingSize(width: view.bounds.width)
        headerView.frame = CGRect(origin: .zero, size: size)
        tableView.tableHeaderView = headerView
        tableView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let headerView = tableView.tableHeaderView as? AccountHeaderView {
            let fitting = headerView.fittingSize(width: view.bounds.width)
            if headerView.frame.height != fitting.height {
                headerView.frame.size.height = fitting.height
                tableView.tableHeaderView = headerView
            }
        }
    }

    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AccountCell.self, forCellReuseIdentifier: "AccountCell")
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
        view.addSubview(tableView)
    }
}

extension AccountViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
        cell.configure(with: item)
        return cell
    }
}

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = sections[indexPath.section].items[indexPath.row]

        switch item.title {
        case "Đăng nhập":
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true, completion: nil)

        case "Đăng ký":
            let registerVC = RegisterViewController()
            registerVC.modalPresentationStyle = .fullScreen
            present(registerVC, animated: true, completion: nil)
            
        case "Đăng xuất":
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            showAlert(message: "Đã đăng xuất") {
                self.viewWillAppear(true) 
            }
        
        case "Donate":
            let donateVC = DonateViewController()
            donateVC.modalPresentationStyle = .fullScreen
            present(donateVC, animated: true, completion: nil)

        case "Thông báo":
            print("Chuyển sang màn hình Thông báo")

        case "Điều khoản sử dụng":
            let termsofVC = TermsofUseViewController()
            termsofVC.modalPresentationStyle = .fullScreen
            present(termsofVC, animated: true, completion: nil)

        default:
            break
        }
    }
}

class AccountCell: UITableViewCell {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let toggleSwitch = UISwitch()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.tintColor = .systemTeal
        contentView.addSubview(iconImageView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(toggleSwitch)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 25),
            iconImageView.heightAnchor.constraint(equalToConstant: 25),

            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(with item: AccountItem) {
        iconImageView.image = UIImage(systemName: item.icon)
        titleLabel.text = item.title
        toggleSwitch.isHidden = !item.isToggle
        toggleSwitch.isOn = item.isOn
        accessoryType = item.isToggle ? .none : .disclosureIndicator
    }
}

extension UIViewController {
    func showAlert(title: String = "Thông báo", message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đóng", style: .default) { _ in completion?() })
        present(alert, animated: true, completion: nil)
    }
}
