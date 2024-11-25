//
//  LocalDataSource.swift
//  News App Task
//
//  Created by mayar on 01/11/2024.
//

import Foundation
import CoreData

class LocalDataSource : LocalDataSourceProtocol{
    
    static let shared = LocalDataSource()
    private init() {}
     
    
     func fetchAllFavorites() -> [Article] {
        let context = UtilityObject.managedContext
        let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            let articles = results.map { Article(from: $0) }
            return articles
        } catch {
            return []
        }
    }
    
    func isArticleFavorite(title: String) -> Bool {
            let context = UtilityObject.managedContext
            let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title == %@", title)
            
            do {
                let results = try context.fetch(fetchRequest)
                return !results.isEmpty
            } catch {
                return false
            }
        }
    
    func addToFavorites(title:String,imageURL:String,description articalDescription:String,author:String) -> Bool {
        
            let context = UtilityObject.managedContext
            let entity = NSEntityDescription.entity(forEntityName: "ArticleEntity", in: context)!
            let newArtical = NSManagedObject(entity: entity, insertInto: context)

            newArtical.setValue(title, forKey: "title")
            newArtical.setValue(imageURL, forKey: "imageURL")
            newArtical.setValue(articalDescription, forKey: "articalDescription")
            newArtical.setValue(author, forKey: "author")
            do {
                try context.save()
                return true;
            } catch {
                return false;
            }
    }
    
     func removeFromFavorites(title: String) -> Bool {
          let context = UtilityObject.managedContext
          let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
          fetchRequest.predicate = NSPredicate(format: "title == %@", title)
          do {
              let results = try context.fetch(fetchRequest)
              if let articleToDelete = results.first {
                  context.delete(articleToDelete)
                  try context.save()
                  return true
              }
          } catch {
          }
          return false
      }
}
