//
//  PantryViewController.swift
//  Final Project
//
//  Created by Tyler Davidson on 12/14/23.
//

import UIKit
import SQLite3

class PantryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Add your outlets for the table view and other UI elements
    @IBOutlet weak var tableView: UITableView!
    
    // Add your data source for the table view
    var pantryItems: [(id: Int, name: String, brand: String, calories: Int, protein: Int, carbs: Int, fat: Int, servings: Int)] = []

    // Add your itemsDBManager instance
    var itemsDBManager: ItemsDBManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        itemsDBManager = ItemsDBManager()
        fetchPantryItems()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    let cellIdentifier = "PantryCell"

    @IBOutlet weak var nameLabel: UIView!
    // Implement UITableViewDelegate and UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pantryItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let pantryItem = pantryItems[indexPath.row]
        print(pantryItem.name)
        cell.textLabel?.text = pantryItem.name
        // You can customize the cell based on your needs
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection (Edit or Remove)
        // You can implement actions to edit or remove the selected pantry item
    }

    // Add your actions for buttons (Edit, Remove, Add)

    @IBAction func editButtonTapped(_ sender: Any) {
    }
    

    @IBAction func deleteButtonTapped(_ sender: Any) {
    }
    

    @IBAction func addButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "YourSegueIdentifier", sender: self)
    }


    // Implement a method to fetch pantry items from the database
    func fetchPantryItems() {
            do {
                // Use the itemsDBManager to read all pantry items from the database
                if let itemsDBManager = itemsDBManager {
                    let pantryItemsFromDB = try itemsDBManager.readAllItems()
                    self.pantryItems = pantryItemsFromDB
                    tableView.reloadData()
                }
            } catch {
                print("Error fetching pantry items: \(error)")
            }
        }
}


