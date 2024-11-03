//
//  FavouriteNewsViewModel.swift
//  News App Task
//
//  Created by mayar on 01/11/2024.
//

import Foundation



class FavouriteNewsViewModel: AddRemoveFavouriteNewsViewModelProtocol {    
     private let localDataSource: LocalDataSourceProtocol
      init(localDataSource: LocalDataSourceProtocol) {
          self.localDataSource = localDataSource
      }
    
    
    func addToFav(title: String, imageURL: String? = "", description: String, author: String) -> Bool {
            return localDataSource.addToFavorites(title: title, imageURL: imageURL ?? "", description: description, author: author)
        }
        
    func removeFromFav(title: String) -> Bool {
            return localDataSource.removeFromFavorites(title: title)
        }
    
}


