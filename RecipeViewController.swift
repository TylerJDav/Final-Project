//
//  RecipeViewController.swift
//  Final Project
//
//  Created by Tyler Davidson on 12/14/23.
//

import UIKit
import WebKit

class RecipeViewController: UIViewController, WKNavigationDelegate {

    // MARK: - Outlets

    @IBOutlet weak var webView: WKWebView!

    // MARK: - Properties

    var recipeAPIManager = APIManager()
    var pantryItem: (id: Int, name: String, brand: String, calories: Int, protein: Int, carbs: Int, fat: Int, servings: Int)?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRandomPantryItem()
    }

    // MARK: - Helper Methods

    func fetchRandomPantryItem() {
        do {
            let itemsDBManager = ItemsDBManager()
            if let randomItem = itemsDBManager.getRandomPantryItem() {
                pantryItem = randomItem
                fetchRecipes()
            }
        } catch {
            print("Error fetching random pantry item: \(error)")
        }
    }

    func fetchRecipes() {
        guard let itemName = pantryItem?.name else {
            return
        }

        recipeAPIManager.fetchRecipes(with: itemName) { [weak self] result in
            switch result {
            case .success(let recipes):
                // Display the name of the first recipe in the label

                // Enable the button to open the URL
                // Set up the URL for the WebView
                if let urlString = recipes.first?.url, let url = URL(string: urlString) {
                    let request = URLRequest(url: url)
                    self?.webView.load(request)
                }

            case .failure(let error):
                print("Error fetching recipes: \(error)")
            }
        }
    }

    // MARK: - Actions

    @IBAction func recipeLinkButtonTapped(_ sender: UIButton) {
        // Open the WebView when the button is tapped
        webView.isHidden = false
    }
}

