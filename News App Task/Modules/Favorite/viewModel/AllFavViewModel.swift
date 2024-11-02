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
//        print("articales\( articles)")
    }
    
    static func  isArticleFavorite(title: String) -> Bool{
        print(" the isArticleFavorite is \(title )")
        
        return LocalDataSource.isArticleFavorite(title:title)
    }
}
