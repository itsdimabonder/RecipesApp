//
//  SplashViewController.swift
//  RecipeApp
//
//  Created by Dmitri Bondartchev on 22/11/2024.
//

import UIKit
import Combine

class SplashViewController: UIViewController {
    
    //MARK: - Properties
    private var viewModel: SplashViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: - IBOutlets
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        prepareData()
    }
    
    //MARK: - Initializer
    init(viewModel: SplashViewModel ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: - Private Methods
    private func prepareData() {
        viewModel.startFetchingRecipes()
    }
    
    private func addObservers() {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                print("Event received: \(event)")
                self.handleSplashEvent(event)
            }
            .store(in: &cancellables)
    }

    private func handleSplashEvent(_ event: SplashViewModelStateEvents) {
        switch event {
        case .startLoading:
            activityIndicatorView.startAnimating()
        case .recipesFetched:
            activityIndicatorView.stopAnimating()
            viewModel.navigateToRecipes()
        case .showError(let message):
            activityIndicatorView.stopAnimating()
            showAlert(message: message)
        }
    }
}

