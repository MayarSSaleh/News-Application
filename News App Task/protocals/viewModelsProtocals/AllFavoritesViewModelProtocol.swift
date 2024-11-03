//
//  AllFavoritesViewModelProtocol.swift
//  News App Task
//
//  Created by mayar on 03/11/2024.
//

import Foundation

protocol AllFavoritesViewModelProtocol {
    var numberOfArticles: Int { get }
    func article(at index: Int) -> Article
    func fetchFavorites()
    func isArticleFavorite(title: String) -> Bool
}
