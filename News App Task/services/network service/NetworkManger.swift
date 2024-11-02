//
//  NetworkManger.swift
//  News App Task
//
//  Created by mayar on 01/11/2024.
//

import Foundation
import Combine

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}

    func fetchArticles(from urlString: String) -> AnyPublisher<[Article], Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ArticleResponse.self, decoder: JSONDecoder())
            .map { $0.articles }
            .eraseToAnyPublisher()
    }
    
    
}
