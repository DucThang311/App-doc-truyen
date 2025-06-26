//
//  MainTabBarViewController.swift
//  StoryApp
//
//  Created by Mạc Đức Thắng on 12/6/25.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Trang chủ", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let followVC = UINavigationController(rootViewController: FollowViewController())
        followVC.tabBarItem = UITabBarItem(title: "Theo dõi", image: UIImage(systemName: "book.circle"), tag: 1)
        
        let discussVC = UINavigationController(rootViewController: DiscussViewController())
        discussVC.tabBarItem = UITabBarItem(title: "Thảo luận mới", image: UIImage(systemName: "text.bubble.rtl"), tag: 2)
        
        let rankVC = UINavigationController(rootViewController: RankViewController())
        rankVC.tabBarItem = UITabBarItem(title: "BXH", image: UIImage(systemName: "list.number"), tag: 3)
        
        let accountVC = UINavigationController(rootViewController: AccountViewController())
        accountVC.tabBarItem = UITabBarItem(title: "Tôi", image: UIImage(systemName: "person.circle.fill"), tag: 4)
        
        viewControllers = [homeVC, followVC, discussVC, rankVC, accountVC]
        
    }

}

