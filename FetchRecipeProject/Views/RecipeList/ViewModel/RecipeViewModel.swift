//
//  RecipeViewModel.swift
//  FetchRecipeProject
//
//  Created by David Owen on 10/25/24.
//

import Foundation

enum SortOrder: String, CaseIterable {
    case nameAsc = "Name A - Z"
    case nameDesc = "Name Z - A"
    case cuisineAsc = "Cuisine A - Z"
    case cuisineDesc = "Cuisine Z - A"
}

@MainActor
final class RecipeViewModel: ObservableObject {
    @Published var allRecipes: [Recipe]?
    @Published var isErrorOnRecipe = false
    @Published var searchableTerm = ""
    @Published var cuisines: [String] = []
    @Published var filter: String = ""
    @Published var sortOrder = SortOrder.nameAsc
    @Published var selectedRecipe: Recipe? = nil

    var visibleRecipes: [Recipe] {
        if let allRecipes {
            var sortedRecipes: [Recipe] =  allRecipes
            do {
                sortedRecipes = try allRecipes.sorted(by: sortFunction())
            } catch {
                print("Unable to sort recipes: \(error)")
            }
            if searchableTerm.isEmpty {
                if filter.isEmpty {
                    return sortedRecipes
                } else {
                    return sortedRecipes.filter({$0.cuisine == filter})
                }
            } else {
                if filter.isEmpty {
                    return sortedRecipes.filter({$0.name.localizedCaseInsensitiveContains(searchableTerm)})
                } else {
                    return sortedRecipes.filter({$0.cuisine == filter && $0.name.localizedCaseInsensitiveContains(searchableTerm)})
                }
            }
        } else {
            return []
        }
    }

    var filterValuesAsString: String {
        var returnString = "No results found for \(searchableTerm)"
        if filter.isEmpty {
            return "\(returnString)."
        } else {
            returnString += " for the cuisine of \(filter)."
            return returnString
        }
    }

    var isRecipesEmpty: Bool {
        if let allRecipes {
            return allRecipes.isEmpty
        }
        return false
    }

    var isVisibleRecipesEmpty: Bool {
        visibleRecipes.isEmpty
    }

    private func sortFunction() -> (Recipe, Recipe) throws -> Bool {
        switch sortOrder {
        case .nameAsc:
            return {$0.name < $1.name}
        case .nameDesc:
            return {$0.name > $1.name}
        case .cuisineAsc:
            return {$0.cuisine < $1.cuisine}
        case .cuisineDesc:
            return {$0.cuisine > $1.cuisine}
        }
    }

    func getRecipes(from urlString: String) async {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                print("Data: \(data)")
                let decodedRecipes = try jsonDecoder.decode(RecipeResponse.self, from: data)
                allRecipes = decodedRecipes.recipes
                setCuisines()
            } catch {
                print("Failed to get recipes: \(error)")
                isErrorOnRecipe = true
            }
        }
    }

    private func setCuisines() {
        for recipe in visibleRecipes {
            if !cuisines.contains(recipe.cuisine) {
                cuisines.append(recipe.cuisine)
            }
        }
    }

    func setFilter(to newFilter: String) {
        if newFilter == filter {
            filter = ""
        } else {
            filter = newFilter
        }
    }

    func isFilter(_ cuisineOption: String) -> Bool {
        return cuisineOption == filter
    }

    func isSortOrder(_ sortOrderOption: SortOrder) -> Bool {
        return sortOrderOption == sortOrder
    }
}
