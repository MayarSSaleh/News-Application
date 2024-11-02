//
//  Article.swift
//  News App Task
//
//  Created by mayar on 01/11/2024.
//

import Foundation

class Article: Decodable {
    var author: String?
    var title: String
    var description: String?
    var url: String
    var urlToImage: String?
    var publishedAt: String
    var content: String?
    
    init(author: String? = nil, title: String, description: String? = nil, url: String, urlToImage: String? = nil, publishedAt: String, content: String? = nil) {
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
}

class ArticleResponse: Decodable {
   var articles: [Article]
}
