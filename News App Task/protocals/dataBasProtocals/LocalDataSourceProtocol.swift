//
//  LocalDataSourceProtocol.swift
//  News App Task
//
//  Created by mayar on 03/11/2024.
//

import Foundation

protocol LocalDataSourceProtocol {
    func fetchAllFavorites() -> [Article]
    func isArticleFavorite(title: String) -> Bool
    func addToFavorites(title: String, imageURL: String, description: String, author: String) -> Bool
    func removeFromFavorites(title: String) -> Bool
}

