//
//  RecipesViewController.swift
//  RecipeApp
//
//  Created by Dmitri Bondartchev on 22/11/2024.
//

import UIKit
import Combine

class RecipesViewController: UIViewController {
    
    //MARK: - Properties
    private var viewModel: RecipesViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegates()
        addObservers()
    }
    
    //MARK: - Initializer
    init(viewModel: RecipesViewModel ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    
    //MARK: - Private Methods
    private func configureDelegates() {
        tableView.register(UINib(nibName: Constants.recipeNibName, bundle: nil), forCellReuseIdentifier: Constants.recipeCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func addObservers() {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                print("Event received: \(event)")
                self.handleRecipesEvent(event)
            }
            .store(in: &cancellables)
    }

    private func handleRecipesEvent(_ event: RecipesViewModelStateEvents) {
        switch event {
        case .bioMetricSuccess(let encryptedData):
            navigateToRecipeDetails(with: encryptedData)
        case .bioMetricEncryptionFailed(let message):
            showAlert(message: message)
        }
    }
    
    private func navigateToRecipeDetails(with encryptedData: Data) {
        viewModel.navigateToRecipeDetails(encryptedData)
    }
}

//MARK: - UITableView Delegate & DataSource
extension RecipesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.recipesDataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.recipeCellIdentifier, for: indexPath) as? RecipeTableViewCell else { return UITableViewCell() }
        let recipe = viewModel.recipesDataSource?[indexPath.row]
        cell.configureCell(with: recipe)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedRecipe = viewModel.recipesDataSource?[indexPath.row] else { return }
        viewModel.selectedRecipeTapped(recipe: selectedRecipe)
    }
}

