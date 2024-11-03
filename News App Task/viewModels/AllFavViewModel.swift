//
//  AllFavViewModel.swift
//  News App Task
//
//  Created by mayar on 02/11/2024.
//

import Foundation


class AllFavoritesViewModel :AllFavoritesViewModelProtocol {
    
    private var articles: [Article] = []
    private let localDataSource: LocalDataSourceProtocol
      
      init(localDataSource: LocalDataSourceProtocol = LocalDataSource()) {
          self.localDataSource = localDataSource
      }
    
    
    var numberOfArticles: Int {
        return articles.count
    }
    
    func article(at index: Int) -> Article {
        return articles[index]
    }

    func fetchFavorites() {
        articles = localDataSource.fetchAllFavorites()
    }
    
    func isArticleFavorite(title: String) -> Bool{
        return localDataSource.isArticleFavorite(title:title)
    }
}
