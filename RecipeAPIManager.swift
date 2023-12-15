//
//  RecipeAPIManager.swift
//  Final Project
//
//  Created by Tyler Davidson on 12/14/23.
//  https://developer.edamam.com/edamam-docs-recipe-api

import Foundation

class APIManager {
    // MARK: - Properties

    static let shared = APIManager()
    
    private let baseURL = "https://api.edamam.com/api/recipes/v2"
    private let appID = "23a2996a"
    private let appKey = "cfce4b5d10e85d517a4e854a030a2673"
    private let mealType = "Dinner"

    // MARK: - Fetch Recipes

    func fetchRecipes(with keywords: String, completion: @escaping (Result<[(label: String, ingredientLines: [String], url: String)], Error>) -> Void) {
        guard let url = makeURL(with: keywords) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }

            do {
                let recipes = try JSONDecoder().decode(RecipeResponse.self, from: data)
                let simplifiedRecipes = recipes.hits.map { hit in
                    let recipe = hit.recipe
                    return (label: recipe.label, ingredientLines: recipe.ingredientLines, url: recipe.url)
                }
                completion(.success(simplifiedRecipes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Helper Methods

    private func makeURL(with keywords: String) -> URL? {
        let urlString = "\(baseURL)?type=public&q=\(keywords)&app_id=\(appID)&app_key=\(appKey)&mealType=\(mealType)"
        print(urlString)
        return URL(string: urlString)
    }
}

struct RecipeResponse: Decodable {
    let hits: [Hit]

    struct Hit: Decodable {
        let recipe: Recipe
    }

    struct Recipe: Decodable {
        let label: String
        let ingredientLines: [String]
        let url: String
    }
}
