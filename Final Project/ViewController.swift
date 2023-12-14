//
//  ViewController.swift
//  Final Project
//
//  Created by Tyler Davidson on 12/13/23.
//

import UIKit

class ViewController: UIViewController {
    
    var databaseManager: DatabaseManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        databaseManager = DatabaseManager()
    }
    
    private func showAlert(message: String) {
            let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    
    deinit {
        databaseManager = nil
    }
}
