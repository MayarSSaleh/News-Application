//
//  ArticleViewModel.swift
//  News App Task
//
//  Created by mayar on 01/11/2024.
//

import Foundation
import Combine

class ArticlesViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var filteredArticles: [Article] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService = NetworkManager.shared

  

    func fetchArticles(for type: FetchType, from date: String? = nil, searchQuery: String? = nil) {
        isLoading = true
       /*
    https://newsapi.org/v2/everything?q=apple&from=2024-10-31&to=2024-10-31&sortBy=popularity&apiKey=20c2eab9e362409fa8c33473d8b7c86e
        
    https://newsapi.org/v2/everything?q=tesla&from=2024-09-30&sortBy=publishedAt&apiK ey=
        */
        // Construct the URL based on the type of fetch
        let urlString: String
        switch type {
        case .general:
            urlString = "https://newsapi.org/v2/everything?q=apple&from=2024-10-31&sortBy=popularity&apiKey=20c2eab9e362409fa8c33473d8b7c86e"
            
            print(" urlString .general \(urlString)")

        case .userDefinedDate:
            guard let date = date else { return }
            urlString = "https://newsapi.org/v2/everything?q=apple&from=\(date)&sortBy=popularity&apiKey=20c2eab9e362409fa8c33473d8b7c86e"
            
            print(" urlString .userDefinedDate \(urlString)")
            
        case .search:
            guard let query = searchQuery else { return }
            urlString = "https://newsapi.org/v2/everything?q=\(query)&from=2024-10-31&sortBy=popularity&apiKey=20c2eab9e362409fa8c33473d8b7c86e"
            print(" urlString searchQuery \(urlString)")
        }

        networkService.fetchArticles(from: urlString)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] articles in
                // Filter out articles with nil values for essential fields
                self?.articles = articles.filter { article in
                    return article.title != "[Removed]"
                }
                self?.filteredArticles = self?.articles ?? []
            })
            .store(in: &cancellables)
    }
}

// Enum to define the fetch type
enum FetchType {
    case general
    case userDefinedDate
    case search
}
