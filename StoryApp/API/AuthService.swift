//
//  AuthService.swift
//  StoryApp
//
//  Created by Mạc Đức Thắng on 18/6/25.
//

import Foundation
import Alamofire

class AuthService {
    static let shared = AuthService()
    private let baseURL = "http://localhost:3000/api/auth" // thay localhost nếu cần

    private init() {}

    func login(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(baseURL)/login"
        let parameters: [String: String] = ["username": username, "password": password]

        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseDecodable(of: LoginResponse.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result.token))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func register(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(baseURL)/register"
        let parameters: [String: String] = ["username": username, "password": password]

        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).response { response in
            if let data = response.data, let message = try? JSONDecoder().decode(MessageResponse.self, from: data) {
                completion(.success(message.message))
            } else {
                completion(.failure(response.error ?? NSError(domain: "", code: 0)))
            }
        }
    }
}

struct LoginResponse: Decodable {
    let token: String
}

struct MessageResponse: Decodable {
    let message: String
}
