//
//  Config.swift
//  RecipeApp
//
//  Created by Dmitri Bondartchev on 22/11/2024.
//

import Foundation

class Config {
    
    static var baseURL: String {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
            fatalError("BaseURL key not set in Info.plist")
        }
        return url
    }

}
