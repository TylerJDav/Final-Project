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
    var db: OpaquePointer?

    init() throws {
        guard let databasePath = Bundle.main.path(forResource: "groceryitems", ofType: "sqlite") else {
            throw DatabaseError.databaseOpenFailed("Unable to find the database file in the project.")
        }

        if sqlite3_open(databasePath, &db) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            throw DatabaseError.databaseOpenFailed("Error opening database: \(errmsg)")
        }
    }

    deinit {
        sqlite3_close(db)
    }

    // MARK: - Create Item

    func addItem(name: String, brand: String, calories: Int, protein: Int, carbs: Int, fat: Int, servings: Int) throws {
        let queryString = "INSERT INTO FoodItems (FoodName, FoodBrand, Calories, ProteinGrams, CarbGrams, FatGrams, Servings) VALUES (?, ?, ?, ?, ?, ?, ?)"

        var stmt: OpaquePointer?

        guard sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) == SQLITE_OK else {
            throw DatabaseError.statementPrepareFailed("Error preparing insert statement")
        }

        defer {
            sqlite3_finalize(stmt)
        }

        guard sqlite3_bind_text(stmt, 1, name, -1, nil) == SQLITE_OK,
              sqlite3_bind_text(stmt, 2, brand, -1, nil) == SQLITE_OK,
              sqlite3_bind_int(stmt, 3, Int32(calories)) == SQLITE_OK,
              sqlite3_bind_int(stmt, 4, Int32(protein)) == SQLITE_OK,
              sqlite3_bind_int(stmt, 5, Int32(carbs)) == SQLITE_OK,
              sqlite3_bind_int(stmt, 6, Int32(fat)) == SQLITE_OK,
              sqlite3_bind_int(stmt, 7, Int32(servings)) == SQLITE_OK else {
            throw DatabaseError.statementBindFailed("Error binding values to insert statement")
        }

        guard sqlite3_step(stmt) == SQLITE_DONE else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            throw DatabaseError.statementStepFailed("Error inserting item: \(errmsg)")
        }
    }
    
    // MARK: - Read Item

    func readItem(withId id: Int) -> (name: String, brand: String, calories: Int, protein: Int, carbs: Int, fat: Int, servings: Int)? {
        let queryString = "SELECT * FROM FoodItems WHERE ID = ?"

        var stmt: OpaquePointer?

        guard sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) == SQLITE_OK else {
            print("Error preparing read statement")
            return nil
        }

        defer {
            sqlite3_finalize(stmt)
        }

        guard sqlite3_bind_int(stmt, 1, Int32(id)) == SQLITE_OK else {
            print("Error binding ID to read statement")
            return nil
        }

        guard sqlite3_step(stmt) == SQLITE_ROW else {
            print("No item found with ID \(id)")
            return nil
        }

        let name = String(cString: sqlite3_column_text(stmt, 1))
        let brand = String(cString: sqlite3_column_text(stmt, 2))
        let calories = Int(sqlite3_column_int(stmt, 3))
        let protein = Int(sqlite3_column_int(stmt, 4))
        let carbs = Int(sqlite3_column_int(stmt, 5))
        let fat = Int(sqlite3_column_int(stmt, 6))
        let servings = Int(sqlite3_column_int(stmt, 7))

        return (name, brand, calories, protein, carbs, fat, servings)
    }

    // MARK: - Update Item

    func updateItem(id: Int, name: String, brand: String, calories: Int, protein: Int, carbs: Int, fat: Int, servings: Int) throws {
        let queryString = "UPDATE FoodItems SET FoodName = ?, FoodBrand = ?, Calories = ?, ProteinGrams = ?, CarbGrams = ?, FatGrams = ?, Servings = ? WHERE ID = ?"

        var stmt: OpaquePointer?

        guard sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) == SQLITE_OK else {
            throw DatabaseError.statementPrepareFailed("Error preparing update statement")
        }

        defer {
            sqlite3_finalize(stmt)
        }

        guard sqlite3_bind_text(stmt, 1, name, -1, nil) == SQLITE_OK,
              sqlite3_bind_text(stmt, 2, brand, -1, nil) == SQLITE_OK,
              sqlite3_bind_int(stmt, 3, Int32(calories)) == SQLITE_OK,
              sqlite3_bind_int(stmt, 4, Int32(protein)) == SQLITE_OK,
              sqlite3_bind_int(stmt, 5, Int32(carbs)) == SQLITE_OK,
              sqlite3_bind_int(stmt, 6, Int32(fat)) == SQLITE_OK,
              sqlite3_bind_int(stmt, 7, Int32(servings)) == SQLITE_OK,
              sqlite3_bind_int(stmt, 8, Int32(id)) == SQLITE_OK else {
            throw DatabaseError.statementBindFailed("Error binding values to update statement")
        }

        guard sqlite3_step(stmt) == SQLITE_DONE else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            throw DatabaseError.statementStepFailed("Error updating item: \(errmsg)")
        }
    }

    // MARK: - Delete Item
    
    func deleteItem(withId id: Int) throws {
            let queryString = "DELETE FROM FoodItems WHERE ID = ?"

            var stmt: OpaquePointer?

            guard sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) == SQLITE_OK else {
                throw DatabaseError.statementPrepareFailed("Error preparing delete statement")
            }

            defer {
                sqlite3_finalize(stmt)
            }

            guard sqlite3_bind_int(stmt, 1, Int32(id)) == SQLITE_OK else {
                throw DatabaseError.statementBindFailed("Error binding ID to delete statement")
            }

            guard sqlite3_step(stmt) == SQLITE_DONE else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                throw DatabaseError.statementStepFailed("Error deleting item: \(errmsg)")
            }
        }
   
}
