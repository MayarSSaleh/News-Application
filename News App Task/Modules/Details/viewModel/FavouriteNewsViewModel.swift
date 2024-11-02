//
//  FavouriteNewsViewModel.swift
//  News App Task
//
//  Created by mayar on 01/11/2024.
//

import Foundation
import CoreData

class FavouriteNewsViewModel{
    
    static func addToFav(title:String,imageURL:String? = "" ,descrption:String,author:String) -> Bool {
          return  LocalDataSource.addToFav(title:title,imageURL:imageURL ?? "",descrption:descrption,author:author)
    }
    
    static func removeFromFav(title: String) -> Bool {
            return LocalDataSource.removeFromFav(title: title)
        }
    
}

/**
 private func removeFromFavorites(title: String) {
     // Implement the logic to remove the article from favorites
     let removeStatus = FavouriteNewsViewModel.removeFromFav(title: title)
     
     if removeStatus {
         print("Successfully removed from favorites.")
         // Optionally, show a message or update the UI
     } else {
         print("Failed to remove from favorites.")
         // Optionally, show an error message
     }
 }

 
 
 */
