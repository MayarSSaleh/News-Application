//
//  NetworkManger.swift
//  News App Task
//
//  Created by mayar on 01/11/2024.
//

import Foundation
import Combine

class NetworkManager : NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    private init() {}
        
     private func createURL(from urlString: String) -> URL? {
          return URL(string: urlString)
      }
    
    
     func fetchArticles(from urlString: String) -> AnyPublisher<[Article], Error> {
        guard let url = createURL(from: urlString) else {
                   return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
               }
         print(" url\(url)")
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
         /* The publisher outputs a tuple containing the downloaded data and response. here map extracting the data from the tuple.
         the $0 syntax is shorthand for the first argument in a closure,(yes.i have only one response)
         */
            .decode(type: ArticleResponse.self, decoder: JSONDecoder())
            .map { $0.articles }//extracts the articles array from the ArticleResponse
            .eraseToAnyPublisher() 
         /* to expose an instance of AnyPublisher to the downstream subscriber, rather than this publisher’s actual type. This form of type erasure preserves abstraction across API boundaries, such as different modules. When you expose your publishers as the AnyPublisher type, you can change the underlying implementation over time without affecting existing clients.
          
          convert the publisher chain
         (Combine's operators (like map, decode, etc.) return a new publisher each time they are applied, which creates complex and deeply nested types)
         into an AnyPublisher<[Article], Error> so hid implmenetation ,
         make it easly to change in it without need to change the return type
    */
}
       
}
