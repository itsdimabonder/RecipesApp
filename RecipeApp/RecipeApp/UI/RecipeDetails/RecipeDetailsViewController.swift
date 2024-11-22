//
//  RecipeDetailsViewController.swift
//  RecipeApp
//
//  Created by Dmitri Bondartchev on 22/11/2024.
//

import UIKit
import Kingfisher
import Combine

class RecipeDetailsViewController: UIViewController {
    
    //MARK: - Properties
    private var viewModel: RecipeDetailsViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: - IBOutlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var dishImageView: UIImageView!
    @IBOutlet private weak var carboLabel: UILabel!
    @IBOutlet private weak var caloriesLabel: UILabel!
    @IBOutlet private weak var fatsLabel: UILabel!
    @IBOutlet weak var infoStack: UIStackView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
    }
    
    //MARK: - Initializer
    init(viewModel: RecipeDetailsViewModel ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    //MARK: - Private Methods
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

    private func handleRecipesEvent(_ event: RecipeDetailsViewModelStateEvents) {
        switch event {
        case .bioMetricAuthenticationSuccess(recipe: let recipe):
            configureUI(from: recipe)
            showUIContent()
        case .bioMetricAuthenticationFailed(error: let error):
            showAlert(message: error)
        }
    }
    
    private func showUIContent() {
        infoStack.isHidden = false
        nameLabel.isHidden = false
        descriptionLabel.isHidden = false
        dishImageView.isHidden = false
    }
    
    private func configureUI(from recipe: Recipe) {
        
        nameLabel.text = recipe.name
        descriptionLabel.text = recipe.description
        carboLabel.text = recipe.carbos
        caloriesLabel.text = recipe.calories
        fatsLabel.text = recipe.fats
        
        guard let imageUrl = URL(string: recipe.image ?? "") else { return }
        dishImageView.kf.setImage(with: imageUrl)
    }
}

