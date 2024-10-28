//
//  ContentView.swift
//  FetchRecipeProject
//
//  Created by David Owen on 10/24/24.
//

import SwiftUI
import YouTubePlayerKit

struct RecipesView: View {
    @StateObject var viewModel = RecipeViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isErrorOnRecipe {
                    ErrorView(errorTitle: "Error loading recipes", errorImage: "exclamationmark.triangle")
                } else if viewModel.isRecipesEmpty {
                    ErrorView(errorTitle: "No recipes exist", errorImage: "exclamationmark.triangle")
                } else {
                    RecipeListView(viewModel: viewModel)
                }
            }
            .sheet(item: $viewModel.selectedRecipe, content: { recipe in
                SelectedRecipeSheetView(recipe: recipe)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ToolBarFilterMenu(viewModel: viewModel)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    ToolBarSortMenu(viewModel: viewModel)
                }
            }
        }
        .task {
            await viewModel.getRecipes(from: Constants.activeLink)
        }
    }
}

struct ToolBarFilterMenu: View {
    @ObservedObject var viewModel: RecipeViewModel
    var body: some View {
        Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
            ForEach(viewModel.cuisines.sorted(), id: \.self) { cuisine in
                Button {
                    viewModel.setFilter(to: cuisine)
                } label: {
                    HStack {
                        ToolBarMenuItem(name: cuisine, isActive: viewModel.isFilter(cuisine))
                    }
                }
            }
        }
    }
}

struct ToolBarSortMenu: View {
    @ObservedObject var viewModel: RecipeViewModel
    var body: some View {
        Menu("Sort", systemImage: "arrow.up.arrow.down") {
            ForEach(SortOrder.allCases, id: \.self) { sortOrder in
                Button {
                    viewModel.sortOrder = sortOrder
                } label: {
                    ToolBarMenuItem(name: sortOrder.rawValue, isActive: viewModel.isSortOrder(sortOrder))
                }
            }
        }
    }
}

struct ToolBarMenuItem: View {
    let name: String
    let isActive: Bool
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Image(systemName: isActive ? "checkmark.circle" : "circle")
        }
    }
}

#Preview {
    RecipesView()
}
