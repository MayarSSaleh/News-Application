//
//  FetchByCategory.swift
//  News App Task
//
//  Created by mayar on 24/11/2024.
//

import Foundation
import Combine

class FetchByCategory {
    
    @Published var articles: [Article] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    var categories = data.categories

    private var selectedCategory = "general"
    
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    private var isLastPage = false
    
    private var networkService: NetworkManagerProtocol
         
     init(networkService: NetworkManagerProtocol) {
         self.networkService = networkService
     }
//https:newsapi.org/v2/top-headlines?category=general&apiKey=20c2eab9e362409fa8c33473d8b7c86e

    private func constructURLForCategory(category: String, page: Int) -> String {
        selectedCategory = category.lowercased()
        return "\(Constants.API.baseURLForCategory)\(selectedCategory)&apiKey=\(Constants.API.apiKey)"
        }
//https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=20c2eab9e362409fa8c33473d8b7c86e
    
    private func fetchArticles(from urlString: String, append: Bool = false) {
            guard !isLastPage else { return }
            
            isLoading = true
            networkService.fetchArticles(from: urlString)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                }, receiveValue: { [weak self] articles in
                    guard let self = self else { return }
                    
                    if articles.isEmpty {
                        self.isLastPage = true
                    } else {
                        if append {
                            self.articles.append(contentsOf: articles.filter { article in
                                return article.title != "[Removed]"
                            })
                        } else {
                            self.articles = articles.filter { article in
                                return article.title != "[Removed]"
                            }
                        }
                    }
                })
                .store(in: &cancellables)
        }
    
    func fetchArticlesByCategory(category: String, append: Bool = false) {
        let urlString = constructURLForCategory(category: category, page: currentPage)
        fetchArticles(from: urlString, append: append)
    }
    
    func loadMoreArticles(resultAbout: String?) {
            guard !isLoading else { return }
            currentPage += 1
        fetchArticlesByCategory(category: selectedCategory,append: true )
     }
        
    func resetPagination() {
            currentPage = 1
            isLastPage = false
            articles = []
        }
    
    private func handleError(_ error: Error) {
            if let fetchError = error as? FetchError {
                switch fetchError {
                case .networkError(let message):
                    errorMessage = message
                case .dataParsingError:
                    errorMessage = "Failed to parse data."
                }
            } else {
                errorMessage = error.localizedDescription
            }
        }
}

