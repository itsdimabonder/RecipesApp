//
//  RecipeService.swift
//  RecipesApp
//
//  Created by Dmitri Bondartchev on 21/11/2024.
//

import Foundation

class RecipeService {
    
    private let networkService: NetworkingService?
    
    init(networkService: NetworkingService?) {
        self.networkService = networkService
    }
    
    //MARK: - Get Recipes
    func getRecipes() async throws -> [Recipe]? {
        return try await networkService?.request(for: .getRecipes, method: .get)
    }

}
