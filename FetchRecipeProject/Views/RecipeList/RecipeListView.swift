//
//  RecipeListView.swift
//  FetchRecipeProject
//
//  Created by David Owen on 10/28/24.
//

import SwiftUI
import Kingfisher

struct RecipeListView: View {
    @ObservedObject var viewModel: RecipeViewModel
    var body: some View {
        List(viewModel.visibleRecipes) { recipe in
            RecipeListElementView(recipe: recipe)
                .onTapGesture {
                    viewModel.selectedRecipe = recipe
                }
        }
        .overlay( Group {
            if viewModel.allRecipes == nil {
                ProgressView()
            } else {
                if viewModel.isVisibleRecipesEmpty {
                    ErrorView(errorTitle: "No recipes found", errorImage: "magnifyingglass", errorBody: viewModel.filterValuesAsString)
                }
            }
        })
        .refreshable {
            await viewModel.getRecipes(from: Constants.activeLink)
        }
        .searchable(text: $viewModel.searchableTerm)
    }
}

struct RecipeListElementView: View {
    let recipe: Recipe
    var body: some View {
        HStack {
            KFImage(URL(string: recipe.photoUrlSmall ?? ""))
                .placeholder {
                    ProgressView()
                }
                .resizable()
                .frame(width: 74, height: 74)
                .clipShape(.rect(cornerRadius: 10))

            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                    .minimumScaleFactor(0.75)
                    .lineLimit(1)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
            }
        }
    }
}

#Preview {
    RecipeListView(viewModel: RecipeViewModel())
}
