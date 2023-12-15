//
//  AddToPantryViewController.swift
//  Final Project
//
//  Created by Tyler Davidson on 12/14/23.
//

import UIKit

class AddToPantryViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var foodBrandTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var proteinGramsTextField: UITextField!
    @IBOutlet weak var carbGramsTextField: UITextField!
    @IBOutlet weak var fatGramsTextField: UITextField!
    @IBOutlet weak var servingsTextField: UITextField!

    // MARK: - Properties

    var editedItem: (id: Int, name: String, brand: String, calories: Int, protein: Int, carbs: Int, fat: Int, servings: Int)?
    var editMode: Bool = false

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Populate the text fields with the details of the selected item (if in edit mode)
        if let editedItem = editedItem {
            foodNameTextField.text = editedItem.name
            foodBrandTextField.text = editedItem.brand
            caloriesTextField.text = "\(editedItem.calories)"
            proteinGramsTextField.text = "\(editedItem.protein)"
            carbGramsTextField.text = "\(editedItem.carbs)"
            fatGramsTextField.text = "\(editedItem.fat)"
            servingsTextField.text = "\(editedItem.servings)"
        }
    }

    // MARK: - Actions

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let name = foodNameTextField.text,
                  let brand = foodBrandTextField.text,
                  let caloriesText = caloriesTextField.text, let calories = Int(caloriesText),
                  let proteinText = proteinGramsTextField.text, let protein = Int(proteinText),
                  let carbText = carbGramsTextField.text, let carbs = Int(carbText),
                  let fatText = fatGramsTextField.text, let fat = Int(fatText),
                  let servingsText = servingsTextField.text, let servings = Int(servingsText)
            else {
                // Handle the case where some required fields are not filled
                print("Please fill in all required fields.")
                return
            }

            do {
                let itemsDBManager = ItemsDBManager()

                if editMode {
                    // If in edit mode, update the existing item
                    try itemsDBManager.updateItem(
                        id: editedItem?.id ?? 0,
                        name: name,
                        brand: brand,
                        calories: calories,
                        protein: protein,
                        carbs: carbs,
                        fat: fat,
                        servings: servings
                    )
                } else {
                    // If not in edit mode, add a new item
                    try itemsDBManager.addItem(
                        name: name,
                        brand: brand,
                        calories: calories,
                        protein: protein,
                        carbs: carbs,
                        fat: fat,
                        servings: servings
                    )
                }

                // Show a success alert
                showSuccessAlert()

                // Implement logic to go back to the previous view controller
                // You can use navigation controller pop or dismiss based on your navigation setup
                navigationController?.popViewController(animated: true)
            } catch {
                // Handle error during save
                print("Error saving item: \(error)")
            }
        }

    func showSuccessAlert() {
        let alertController = UIAlertController(title: "Success", message: "Item saved successfully!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
