//
//  Comic.swift
//  StoryApp
//
//  Created by Mạc Đức Thắng on 12/6/25.
//

struct Comic: Codable {
    let id: Int?
    let title: String
    let imageURL: String
    let genres: String?
    let status: String?
    let updatedAt: String?
    let views: Int?
    let followers: Int?
    let description: String?
    let chapters: [Chapter]?
}

struct Chapter: Codable {
    let id: Int
    let title: String
    let isLocked: Bool
    let images: [String]
}

struct AccountItem {
    let icon: String
    let title: String
    var isToggle: Bool = false
    var isOn: Bool = false
}

struct Discussion: Codable {
    let id: Int
    let userId: Int
    let username: String
    let message: String
    let createdAt: String
}

struct ComicResponse: Codable {
    let carouselImages: [String]
    let chineseComics: [Comic]
    let koreanComics: [Comic]
    let textComics: [Comic]
    
}

