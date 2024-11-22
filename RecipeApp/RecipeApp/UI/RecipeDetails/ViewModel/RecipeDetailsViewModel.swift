//
//  RecipeDetailsViewModel.swift
//  RecipeApp
//
//  Created by Dmitri Bondartchev on 22/11/2024.
//

import Foundation
import Combine


enum RecipeDetailsViewModelStateEvents {
    case bioMetricAuthenticationSuccess(recipe: Recipe)
    case bioMetricAuthenticationFailed(error: String)
}

class RecipeDetailsViewModel {
    
    //MARK: - Properties
    let state = PassthroughSubject<RecipeDetailsViewModelStateEvents, Never>()
    
    private(set) var recipe: Recipe?
    private(set) var encryptedDataObject: Data?
    
    weak var coordinator: AppCoordinator?
    
    //MARK: - Init
    init(encryptedData: Data?) {
        self.encryptedDataObject = encryptedData
        askForBioMetricAuthentication()
    }
    
    //MARK: - Methods
    
    //MARK: - Private Methods
    private func askForBioMetricAuthentication() {
        guard let data = encryptedDataObject else { return }
        
        BiometricManager.decrypt(data: data, type: Recipe.self) { [weak self] result in
            switch result {
            case .success(let recipe):
                print("Recipe decrypted - \(recipe)")
                self?.state.send(.bioMetricAuthenticationSuccess(recipe: recipe))
               
            case .failure(let error):
                self?.state.send(.bioMetricAuthenticationFailed(error: error.localizedDescription))
            }
        }
    }
}
