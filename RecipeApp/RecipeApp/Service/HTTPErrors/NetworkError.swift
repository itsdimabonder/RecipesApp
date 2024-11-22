//
//  NetworkError.swift
//  RecipeApp
//
//  Created by Dmitri Bondartchev on 21/11/2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case unauthorized
    case notFound
    case serverError(code: Int?, message: String)
}
