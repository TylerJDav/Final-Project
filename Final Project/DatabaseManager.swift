//
//  DatabaseManager.swift
//  Final Project
//
//  Created by Tyler Davidson on 12/13/23.
//

import Foundation
import SQLite3

enum DatabaseError: Error {
    case databaseOpenFailed(String)
    case statementPrepareFailed(String)
    case statementBindFailed(String)
    case statementStepFailed(String)
}

class DatabaseManager {
    static let shared = try? DatabaseManager()

    var db: OpaquePointer?

    private init() throws {
        guard let databasePath = Bundle.main.path(forResource: "groceryitems", ofType: "db") else {
            print("Error: Unable to find the database file in the project.")
            throw DatabaseError.databaseOpenFailed("Unable to find the database file in the project.")
        }
        
        if sqlite3_open(databasePath, &db) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error opening database: \(errmsg)")
            throw DatabaseError.databaseOpenFailed("Error opening database: \(errmsg)")
        }
            }

    deinit {
        sqlite3_close(db)
    }
    
    func copyItemsToShoppingList() throws {
            let copyQueryString = """
                INSERT INTO ShoppingItems
                (FoodName, Quantity)
                SELECT FoodName, 1
                FROM FoodItems
                WHERE Servings = 0
            """

            try executeSQLStatement(copyQueryString)
        }
    
    private func executeSQLStatement(_ sql: String) throws {
            guard sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                throw DatabaseError.statementStepFailed("Error executing SQL statement: \(errmsg)")
            }
        }
}

