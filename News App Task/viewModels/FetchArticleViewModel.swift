//
//  ArticleViewModel.swift
//  News App Task
//
//  Created by mayar on 01/11/2024.
//

import Foundation
import Combine

class FetchArticlesViewModel: FetchArticlesViewModelProtocol {
    
    @Published var articles: [Article] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private var networkService: NetworkManagerProtocol
         
     init(networkService: NetworkManagerProtocol) {
         self.networkService = networkService
     }
   
    
    private func constructURL(resultAbout: String? , from date: String?) -> String {
          let query = resultAbout ?? Constants.Default.query
          let fromDate = date ?? Constants.Default.date
          return "\(Constants.API.baseURL)?q=\(query)&from=\(fromDate)&sortBy=popularity&apiKey=\(Constants.API.apiKey)"
      }

      private func fetchArticles(from urlString: String) {
          isLoading = true
          networkService.fetchArticles(from: urlString)
              .receive(on: DispatchQueue.main)
              .sink(receiveCompletion: { [weak self] completion in
                  self?.isLoading = false
                  if case .failure(let error) = completion {
                      self?.handleError(error)
                  }
              }, receiveValue: { [weak self] articles in
                  self?.articles = articles.filter { article in
                      return article.title != "[Removed]"
                  }
              })
              .store(in: &cancellables)
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
        
    
      func fetchArticlesByParameters(resultAbout: String? = nil, from date: String? = nil) {
          let urlString = constructURL(resultAbout: resultAbout, from: date)
          fetchArticles(from: urlString)
      }
}

enum FetchError: Error {
    case networkError(String)
    case dataParsingError
}
