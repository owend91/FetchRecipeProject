//
//  FetchRecipeProjectTests.swift
//  FetchRecipeProjectTests
//
//  Created by David Owen on 10/28/24.
//

import XCTest
@testable import FetchRecipeProject

@MainActor
final class RecipeViewModelTest: XCTestCase {
    func testLoadEmptyApiUrl() async throws {
        let viewModel = RecipeViewModel()

        await viewModel.getRecipes(from: Constants.emptyRecipeUrl)

        XCTAssertNotNil(viewModel.allRecipes)

        if let allRecipes = viewModel.allRecipes {
            XCTAssertEqual(allRecipes.count, 0)
        }

        let errorOnRecipe = viewModel.isErrorOnRecipe
        XCTAssertFalse(errorOnRecipe)
    }

    func testLoadMalformedApiUrl() async throws {
        let viewModel = RecipeViewModel()

        await viewModel.getRecipes(from: Constants.malformedRecipeUrl)

        XCTAssertNil(viewModel.allRecipes)

        XCTAssertTrue(viewModel.isErrorOnRecipe)
    }

    func testLoadValidApiUrl() async throws {
        let viewModel = RecipeViewModel()

        await viewModel.getRecipes(from: Constants.recipeUrl)

        XCTAssertNotNil(viewModel.allRecipes)

        XCTAssertFalse(viewModel.isErrorOnRecipe)

        if let allRecipes = viewModel.allRecipes {
            //At time of writing test, there are 63 recipes in the api.  If this fails, verify that updated API doesn't affect other tests
            XCTAssertEqual(allRecipes.count, 63)
        }

        XCTAssertEqual(viewModel.visibleRecipes.count, 63)

    }

    func testCuisinesPopulateCorrectly() async throws {
        let viewModel = RecipeViewModel()

        XCTAssertEqual(viewModel.cuisines.count, 0)

        await viewModel.getRecipes(from: Constants.recipeUrl)

        XCTAssertEqual(viewModel.cuisines.count, 12)
    }

    func testSearchable() async throws {
        let viewModel = RecipeViewModel()
        await viewModel.getRecipes(from: Constants.recipeUrl)
        viewModel.searchableTerm = "apple"

        XCTAssertEqual(viewModel.visibleRecipes.count, 3)

        viewModel.searchableTerm = "This does not exist"

        XCTAssertEqual(viewModel.visibleRecipes.count, 0)

        viewModel.searchableTerm = "APPLE"

        XCTAssertEqual(viewModel.visibleRecipes.count, 3)
    }

    func testFilter() async throws {
        let viewModel = RecipeViewModel()

        await viewModel.getRecipes(from: Constants.recipeUrl)

        for cuisine in viewModel.cuisines {
            viewModel.filter = cuisine
            if cuisine == "American" {
                XCTAssertEqual(viewModel.visibleRecipes.count, 14)
            } else if cuisine == "British" {
                XCTAssertEqual(viewModel.visibleRecipes.count, 27)
            } else if cuisine == "Canadian" {
                XCTAssertEqual(viewModel.visibleRecipes.count, 5)
            } else if cuisine == "Croatian" {
                XCTAssertEqual(viewModel.visibleRecipes.count, 1)
            } else if cuisine == "French" {
                XCTAssertEqual(viewModel.visibleRecipes.count, 6)
            } else if cuisine == "Greek" {
                XCTAssertEqual(viewModel.visibleRecipes.count, 1)
            } else if cuisine == "Italian" {
                XCTAssertEqual(viewModel.visibleRecipes.count, 1)
            } else if cuisine == "Malaysian" {
                XCTAssertEqual(viewModel.visibleRecipes.count, 2)
            } else if cuisine == "Polish" {
                XCTAssertEqual(viewModel.visibleRecipes.count, 2)
            } else if cuisine == "Portuguese" {
                XCTAssertEqual(viewModel.visibleRecipes.count, 1)
            } else if cuisine == "Russian" {
                XCTAssertEqual(viewModel.visibleRecipes.count, 1)
            } else if cuisine == "Tunisian" {
                XCTAssertEqual(viewModel.visibleRecipes.count, 2)
            } else {
                XCTAssertEqual(cuisine, "NEW CUISINE")
            }
        }
    }

    func testFilterAndSearch() async throws {
        let viewModel = RecipeViewModel()
        await viewModel.getRecipes(from: Constants.recipeUrl)
        viewModel.searchableTerm = "apple"
        viewModel.filter = "British"

        XCTAssertEqual(viewModel.visibleRecipes.count, 2)
    }

    func testSort() async throws {
        let viewModel = RecipeViewModel()
        await viewModel.getRecipes(from: Constants.recipeUrl)

        //Default is alphabetical by name A - Z
        if let first = viewModel.visibleRecipes.first, let last = viewModel.visibleRecipes.last {
            XCTAssertEqual(first.name, "Apam Balik")
            XCTAssertEqual(last.name, "White Chocolate Crème Brûlée")
        }

        for sort in SortOrder.allCases {
            viewModel.sortOrder = sort
            if let first = viewModel.visibleRecipes.first, let last = viewModel.visibleRecipes.last {
                if sort == .nameAsc {
                    XCTAssertEqual(first.name, "Apam Balik")
                    XCTAssertEqual(last.name, "White Chocolate Crème Brûlée")
                } else if sort == .nameDesc {
                    XCTAssertEqual(first.name, "White Chocolate Crème Brûlée")
                    XCTAssertEqual(last.name, "Apam Balik")
                } else if sort == .cuisineAsc {
                    XCTAssertEqual(first.cuisine, "American")
                    XCTAssertEqual(last.cuisine, "Tunisian")
                } else if sort == .cuisineDesc {
                    XCTAssertEqual(first.cuisine, "Tunisian")
                    XCTAssertEqual(last.cuisine, "American")
                } else {
                    XCTAssertEqual(sort.rawValue, "NEW SORT")
                }
            }
        }
    }

    func testFilterValueAsStringForEmptySearchResult() async throws {
        let viewModel = RecipeViewModel()
        await viewModel.getRecipes(from: Constants.recipeUrl)
        viewModel.searchableTerm = "pizza"

        XCTAssertEqual(viewModel.filterValuesAsString, "No results found for pizza.")

        viewModel.filter = "Italian"
        XCTAssertEqual(viewModel.filterValuesAsString, "No results found for pizza for the cuisine of Italian.")
    }

    func testSetFilterFunction() async throws {
        let filter = "American"
        let viewModel = RecipeViewModel()
        await viewModel.getRecipes(from: Constants.recipeUrl)
        viewModel.setFilter(to: filter)

        XCTAssertEqual(viewModel.filter, filter)

        viewModel.setFilter(to: filter)
        XCTAssertTrue(viewModel.filter.isEmpty)
    }

    func testIsFilterFunction() async throws {
        let filter = "American"
        let viewModel = RecipeViewModel()
        await viewModel.getRecipes(from: Constants.recipeUrl)
        viewModel.setFilter(to: filter)

        XCTAssertTrue(viewModel.isFilter(filter))
        XCTAssertFalse(viewModel.isFilter("Italian"))
    }

    func testIsSortOrder() async throws {
        let sortOrder = SortOrder.cuisineAsc
        let viewModel = RecipeViewModel()
        await viewModel.getRecipes(from: Constants.recipeUrl)
        viewModel.sortOrder = sortOrder

        XCTAssertTrue(viewModel.isSortOrder(sortOrder))
        XCTAssertFalse(viewModel.isSortOrder(SortOrder.nameAsc))
    }
}
