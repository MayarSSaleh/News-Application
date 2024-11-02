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
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService = NetworkManager.shared

    func fetchArticles(resultAbout: String? = nil , from date: String? = nil ) {
        isLoading = true
        let urlString: String
            urlString = "https://newsapi.org/v2/everything?q=\(resultAbout ?? "apple")&from=\(date ?? "2024-11-01")&sortBy=popularity&apiKey=0a3cd94367624ce4a68df2a2017e98a8"
        
            print(" urlString searchQuery \(urlString)")
        
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
            })
            .store(in: &cancellables)
    }
}
