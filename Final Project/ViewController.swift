//
//  ViewController.swift
//  Final Project
//
//  Created by Tyler Davidson on 12/13/23.
//

import UIKit

class ViewController: UIViewController {
    
    var itemsDBManager: ItemsDBManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        itemsDBManager = ItemsDBManager()
    }
    
    private func showAlert(message: String) {
            let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    
    deinit {
        itemsDBManager = nil
    }
}
