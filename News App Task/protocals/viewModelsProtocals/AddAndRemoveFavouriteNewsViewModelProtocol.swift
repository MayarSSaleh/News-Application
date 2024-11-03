//
//  AddAndRemoveFavouriteNewsViewModelProtocol.swift
//  News App Task
//
//  Created by mayar on 03/11/2024.
//

import Foundation

protocol AddRemoveFavouriteNewsViewModelProtocol {
    
    func addToFav(title: String, imageURL: String?, description: String, author: String) -> Bool
    func removeFromFav(title: String) -> Bool
    
}
