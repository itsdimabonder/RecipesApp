//
//  AppCoordinator.swift
//  RecipeApp
//
//  Created by Dmitri Bondartchev on 22/11/2024.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
}

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    // MARK: - Initializer
    init(navController: UINavigationController) {
        self.navigationController = navController
        
        setupNavigationAppearence()
    }
    
    
    //MARK: - Private
    private func setupNavigationAppearence() {
        let backButtonImage = UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal).withTintColor(.black)
        navigationController.navigationBar.topItem?.title = ""
        navigationController.navigationBar.backIndicatorImage = backButtonImage
        navigationController.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
    }
    
    //MARK: - Public Navigation Methods
    
    func start() {
        
        //Get baseURL from Config
        guard let baseURL = URL(string: Config.baseURL) else { return }
        // Inject Base URL To Create Networking Service
        
        let service = NetworkingService(baseURL: baseURL)
        
        //Inject Networking Service To Create Recipe Service
        let recipesService = RecipeService(networkService: service)
        
        //Create Splash Entry
        let splashViewModel = SplashViewModel(recipeService: recipesService)
        let splashViewController = SplashViewController(viewModel: splashViewModel)
        
        splashViewModel.coordinator = self

        navigationController.pushViewController(splashViewController, animated: false)
    }
    
    func navigateToRecipes(_ recipes: [Recipe]?) {
        let recipesViewModel = RecipesViewModel(recipes: recipes)
        let recipesViewController = RecipesViewController(viewModel: recipesViewModel)
        
        recipesViewModel.coordinator = self
        navigationController.setViewControllers([recipesViewController], animated: true)
    }
    
    func navigateToRecipeDetails(_ encryptedData: Data?) {
        guard let data = encryptedData else { return }
        
        let recipeDetailsViewModel = RecipeDetailsViewModel(encryptedData: data)
        let recipeDetailsViewController = RecipeDetailsViewController(viewModel: recipeDetailsViewModel)
        
        recipeDetailsViewModel.coordinator = self
        
        navigationController.pushViewController(recipeDetailsViewController, animated: false)
    }

}
