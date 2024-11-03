//
//  NetworkManagerProtocol.swift
//  News App Task
//
//  Created by mayar on 03/11/2024.
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
    func fetchArticles(from urlString: String) -> AnyPublisher<[Article], Error>
}
