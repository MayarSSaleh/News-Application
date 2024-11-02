//
//  FavouriteNewsViewModel.swift
//  News App Task
//
//  Created by mayar on 01/11/2024.
//

import Foundation

protocol FavouriteNewsViewModelProtocol {
    
    func addToFav(title: String, imageURL: String?, description: String, author: String) -> Bool
    func removeFromFav(title: String) -> Bool
    
}


class FavouriteNewsViewModel: FavouriteNewsViewModelProtocol {
        func addToFav(title: String, imageURL: String? = "", description: String, author: String) -> Bool {
            return LocalDataSource.addToFav(title: title, imageURL: imageURL ?? "", descrption: description, author: author)
        }
        
        func removeFromFav(title: String) -> Bool {
            return LocalDataSource.removeFromFav(title: title)
        }
    }


