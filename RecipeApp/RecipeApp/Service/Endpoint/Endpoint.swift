//
//  Endpoint.swift
//  RecipeApp
//
//  Created by Dmitri Bondartchev on 21/11/2024.
//

import Foundation

enum Endpoint {
    
    //get recipes
    case getRecipes
    
    var path: String {
        switch self {
        case .getRecipes:
            return "android-test/recipes.json"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getRecipes:
            return nil
        }
    }
}
