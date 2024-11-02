//
//  AllFavViewModel.swift
//  News App Task
//
//  Created by mayar on 02/11/2024.
//

import Foundation

class FavoritesViewModel {
    private var articles: [Article] = []
    
    var numberOfArticles: Int {
        return articles.count
    }
    
    func article(at index: Int) -> Article {
        return articles[index]
    }

    func fetchFavorites() {
        articles = LocalDataSource.fetchAllFavorites()
    }
    
    static func isArticleFavorite(title: String) -> Bool{
        return LocalDataSource.isArticleFavorite(title:title)
    }
}
