//
//  ComicService.swift
//  StoryApp
//
//  Created by Mạc Đức Thắng on 12/6/25.
//

import Foundation
import Alamofire

class ComicService {
    static let shared = ComicService()
    private init() {}

    private let baseURL = "http://localhost:3000/api"

    func fetchComics(completion: @escaping (ComicResponse?) -> Void) {
        let url = "\(baseURL)/comics"
        AF.request(url).responseDecodable(of: ComicResponse.self) { response in
            switch response.result {
            case .success(let comics):
                completion(comics)
            case .failure(let error):
                print("❌ Lỗi tải comic từ API: \(error)")
                completion(nil)
            }
        }
    }

    func searchComics(keyword: String, completion: @escaping ([Comic]) -> Void) {
        let url = "\(baseURL)/search?q=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        AF.request(url).responseDecodable(of: [Comic].self) { response in
            completion(response.value ?? [])
        }
    }

    func fetchHotComics(completion: @escaping ([Comic]) -> Void) {
        let url = "\(baseURL)/comics/hot"
        AF.request(url).responseDecodable(of: [Comic].self) { response in
            completion(response.value ?? [])
        }
    }

    func fetchComicsByGenre(_ genre: String, completion: @escaping ([Comic]) -> Void) {
        let encodedGenre = genre.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? genre
        let url = "\(baseURL)/comics/genre/\(encodedGenre)"
        AF.request(url).responseDecodable(of: [Comic].self) { response in
            completion(response.value ?? [])
        }
    }
}




