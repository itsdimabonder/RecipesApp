//
//  Recipe.swift
//  RecipeApp
//
//  Created by Dmitri Bondartchev on 22/11/2024.
//

import Foundation

struct Recipe: Codable {
    
    let calories: String?
    let carbos: String?
    let description: String
    let difficulty: Int
    let fats: String?
    let headline: String?
    let id: String?
    let image: String?
    let name: String?
    let proteins: String?
    let thumb: String?
    let time: String?
    let country: String?
    
    
    //optional init
    init(calories: String? = nil, carbos: String? = nil, description: String, difficulty: Int, fats: String? = nil, headline: String? = nil, id: String? = nil, image: String? = nil, name: String? = nil, proteins: String? = nil, thumb: String? = nil, time: String? = nil, country: String? = nil) {
        self.calories = calories
        self.carbos = carbos
        self.description = description
        self.difficulty = difficulty
        self.fats = fats
        self.headline = headline
        self.id = id
        self.image = image
        self.name = name
        self.proteins = proteins
        self.thumb = thumb
        self.time = time
        self.country = country
    }
}
