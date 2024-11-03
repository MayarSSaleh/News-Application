//
//  FetchArticlesViewModelProtocol.swift
//  News App Task
//
//  Created by mayar on 03/11/2024.
//

import Foundation
import Combine

protocol FetchArticlesViewModelProtocol: ObservableObject {
    var articles: [Article] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }

    func fetchArticlesByParameters(resultAbout: String?, from date: String?)
}
