//
//  SplashViewModel.swift
//  RecipeApp
//
//  Created by Dmitri Bondartchev on 22/11/2024.
//

import Foundation
import Combine

//MARK: - SplashViewModelStateEvents
enum SplashViewModelStateEvents {
    case startLoading
    case recipesFetched
    case showError(message: String)
}


//MARK: - SplashViewModel
class SplashViewModel {
    
    //MARK: - Properties
    weak var coordinator: AppCoordinator?
    let state = PassthroughSubject<SplashViewModelStateEvents, Never>()
    let recipeService: RecipeService
    private(set) var recipes: [Recipe]?
    
    
    //MARK: - Init
    init(recipeService: RecipeService) {
        self.recipeService = recipeService
    }
    
    //MARK: - Methods
    func navigateToRecipes() {
        coordinator?.navigateToRecipes(recipes)
    }
    
    //MARK: - Private Methods
    func startFetchingRecipes() {
        
        state.send(.startLoading)
        
        Task {
            do {
                let recipesResponse = try await self.recipeService.getRecipes()
                self.recipes = recipesResponse
                self.state.send(.recipesFetched)
            } catch let error {
                self.state.send(.showError(message: error.localizedDescription))
            }
        }
    }
    
}

