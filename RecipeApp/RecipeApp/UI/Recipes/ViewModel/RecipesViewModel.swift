//
//  RecipesViewModel.swift
//  RecipeApp
//
//  Created by Dmitri Bondartchev on 22/11/2024.
//

import Foundation
import Combine

enum RecipesViewModelStateEvents {
    case bioMetricSuccess(encryptedData: Data)
    case bioMetricEncryptionFailed(message: String)
}

class RecipesViewModel {
    
    //MARK: - Properties
    weak var coordinator: AppCoordinator?
    let state = PassthroughSubject<RecipesViewModelStateEvents, Never>()
    let recipesDataSource: [Recipe]?
    
    //MARK: - Init
    init(recipes: [Recipe]?) {
        self.recipesDataSource = recipes
    }
    
    //MARK: - Methods
    func selectedRecipeTapped(recipe: Recipe) {
        BiometricManager.encrypt(object: recipe) { [weak self] result in
            switch result {
            case .success(let encryptedData):
                self?.state.send(.bioMetricSuccess(encryptedData: encryptedData))
            case .failure(let failure):
                self?.state.send(.bioMetricEncryptionFailed(message: failure.localizedDescription))
            }
        }
    }
    
    func navigateToRecipeDetails(_ encryptedData: Data) {
        coordinator?.navigateToRecipeDetails(encryptedData)
    }
    
    //MARK: - Private Methods
}
