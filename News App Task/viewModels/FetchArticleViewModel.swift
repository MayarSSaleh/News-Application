//
//  ArticleViewModel.swift
//  News App Task
//
//  Created by mayar on 01/11/2024.
//

import Foundation
import Combine

class FetchArticlesViewModel {
    
    @Published var articles: [Article] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    /*
     when cancellables isdeallocated ?
      cancellables set is part of a view model that is instantiated in a view controller, when the view controller is deallocated (for example, when the user navigates away from the screen), the view model is also deallocated, and the cancellables set goes out of scope.so all subscriptions in it are canceled automatically.
     */
    
    private var currentPage = 1
    private var isLastPage = false // Indicates if all pages are fetched
    
    private var networkService: NetworkManagerProtocol
         
     init(networkService: NetworkManagerProtocol) {
         self.networkService = networkService
     }
       
    private func constructURL(resultAbout: String?, from date: String?, page: Int) -> String {
            let query = resultAbout ?? Constants.Default.query
            let fromDate = date ?? Constants.Default.date
            return "\(Constants.API.baseURL)?q=\(query)&from=\(fromDate)&sortBy=popularity&page=\(page)&pageSize=\(Constants.API.pageSize)&apiKey=\(Constants.API.apiKey)"
        }
    
    
    private func fetchArticles(from urlString: String, append: Bool = false) {
            guard !isLastPage else { return } // Stop fetching if all pages are loaded
            
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
        
    func fetchArticlesByParameters(resultAbout: String? = nil, from date: String? = nil, append: Bool = false) {
            let urlString = constructURL(resultAbout: resultAbout, from: date, page: currentPage)
            fetchArticles(from: urlString, append: append)
        }
        
    func loadMoreArticles(resultAbout: String?, from date: String?) {
            guard !isLoading else { return } // Avoid multiple calls at the same time
            currentPage += 1
            fetchArticlesByParameters(resultAbout: resultAbout, from: date, append: true)
        
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

