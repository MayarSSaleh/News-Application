//
//  FavouriteNewsViewModel.swift
//  News App Task
//
//  Created by mayar on 01/11/2024.
//

import Foundation

class FavouriteNewsViewModel{
    
    static func addToFav(title:String,imageURL:String? = "" ,descrption:String,author:String) -> Bool {
          return  LocalDataSource.addToFav(title:title,imageURL:imageURL ?? "",descrption:descrption,author:author)
    }
    
    static func removeFromFav(title: String) -> Bool {
            return LocalDataSource.removeFromFav(title: title)
        }
    
}


