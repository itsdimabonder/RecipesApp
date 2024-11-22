//
//  RecipeTableViewCell.swift
//  RecipeApp
//
//  Created by Dmitri Bondartchev on 22/11/2024.
//

import UIKit
import Kingfisher

class RecipeTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var fatsLabel: UILabel!
    @IBOutlet private weak var caloriesLabel: UILabel!
    @IBOutlet private weak var carbosLabel: UILabel!
    @IBOutlet private weak var thumbImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Public Methods
    func configureCell(with recipe: Recipe?) {
        guard let recipe = recipe else { return }
        
        nameLabel.text = recipe.name
        fatsLabel.text = recipe.fats
        caloriesLabel.text = recipe.calories
        carbosLabel.text = recipe.carbos
        
        //Download Thumbnail Image
        let thumbURL = URL(string: recipe.thumb ?? "")
        thumbImageView.kf.setImage(with: thumbURL)
    }
    
}
