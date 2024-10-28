//
//  RecipeResponse.swift
//  FetchRecipeProject
//
//  Created by David Owen on 10/24/24.
//

import Foundation

struct RecipeResponse: Codable {
    var recipes: [Recipe]
}

struct Recipe: Codable, Identifiable {
    let id: String
    let cuisine: String
    let name: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let sourceUrl: String?
    let youtubeUrl: String?

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case cuisine
        case name
        case photoUrlLarge
        case photoUrlSmall
        case sourceUrl
        case youtubeUrl
    }
}


