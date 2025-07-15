//
//  RankUser.swift
//  StoryApp
//
//  Created by Mạc Đức Thắng on 3/7/25.
//

import Foundation

struct RankUser {
    let username: String
    let commentCount: Int
    var score: Int { commentCount * 10 }
    var rank: Int = 0
    var role: String = "Thường dân"
}

//extension Int {
//    func formattedWithSeparator() -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.groupingSeparator = ","
//        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
//    }
//}

