//
//  ErrorHandling.swift
//  News App Task
//
//  Created by mayar on 24/11/2024.
//

import Foundation

enum FetchError: Error {
    case networkError(String)
    case dataParsingError
}
