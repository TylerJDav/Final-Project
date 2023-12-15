//
//  DatabaseManager.swift
//  Final Project
//
//  Created by Tyler Davidson on 12/13/23.
//

import Foundation
import SQLite3

class ItemsDBManager {
    private let db: OpaquePointer? = DatabaseManager.shared?.db

    // MARK: - Create Item

    func addItem(name: String, brand: String, calories: Int, protein: Int, carbs: Int, fat: Int, servings: Int) throws {
        let queryString = "INSERT INTO pantryitems (FoodName, FoodBrand, Calories, ProteinGrams, CarbGrams, FatGrams, Servings) VALUES (?, ?, ?, ?, ?, ?, ?)"

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
        let queryString = "SELECT * FROM pantryitems WHERE FoodID = ?"

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
    
    func readAllItems() throws -> [(id: Int, name: String, brand: String, calories: Int, protein: Int, carbs: Int, fat: Int, servings: Int)] {
        let queryString = "SELECT * FROM pantryitems"

        var stmt: OpaquePointer?

        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }

        var items: [(id: Int, name: String, brand: String, calories: Int, protein: Int, carbs: Int, fat: Int, servings: Int)] = []

        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let id = Int(sqlite3_column_int(stmt, 0))
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let brand = String(cString: sqlite3_column_text(stmt, 2))
            let calories = Int(sqlite3_column_int(stmt, 3))
            let protein = Int(sqlite3_column_int(stmt, 4))
            let carbs = Int(sqlite3_column_int(stmt, 5))
            let fat = Int(sqlite3_column_int(stmt, 6))
            let servings = Int(sqlite3_column_int(stmt, 7))

            let item = (id: id, name: name, brand: brand, calories: calories, protein: protein, carbs: carbs, fat: fat, servings: servings)
            print(item)
            items.append(item)
        }

        return items
    }


    // MARK: - Update Item

    func updateItem(id: Int, name: String, brand: String, calories: Int, protein: Int, carbs: Int, fat: Int, servings: Int) throws {
        let queryString = "UPDATE pantryitems SET FoodName = ?, FoodBrand = ?, Calories = ?, ProteinGrams = ?, CarbGrams = ?, FatGrams = ?, Servings = ? WHERE FoodID = ?"

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
            let queryString = "DELETE FROM pantryitems WHERE FoodID = ?"

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
    
    // MARK: - Clear Database
    
    func clearDatabase() throws {
            let clearTableString = "DELETE FROM pantryitems"

            if sqlite3_exec(db, clearTableString, nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                throw DatabaseError.statementStepFailed("Error clearing database: \(errmsg)")
            }
        }
    
    // MARK: - Reset Database
    
    func resetDatabase() throws {
            let dropTableString = "DROP TABLE IF EXISTS pantryitems"
            let createTableString = """
                CREATE TABLE IF NOT EXISTS FoodItems (
                    FoodID INTEGER PRIMARY KEY AUTOINCREMENT,
                    FoodName TEXT NOT NULL,
                    FoodBrand TEXT,
                    Calories INTEGER,
                    ProteinGrams INTEGER,
                    CarbGrams INTEGER,
                    FatGrams INTEGER,
                    Servings INTEGER DEFAULT 0
                );
            """
            let populateTableString = """
                INSERT INTO pantryitems
                (FoodName, FoodBrand, Calories, ProteinGrams, CarbGrams, FatGrams, Servings)
                VALUES
                ("Banana","Dole",27,1,30,0,0),
                ("Black Beans","Generic",109,7,20,1,0),
                ("Crackers","Trisket",120,3,20,4,0),
                ("Egg","Walmart",72,6,1,5,0),
                ("French Fries (medium)","McDonald's",320,5,43,15,0),
                ("Hummus","Sabra",150,4,9,11,0),
                ("Ice Cream (coffee flavor)","Breyers",130,2,15,7,0),
                ("Kobe Ribeye","Vons",270,21,0,21,0),
                ("Lemon","Generic",19,1,6,1,0),
                ("Pork Rinds","Juan Chicharron",167,17,0,11,0),
                ("Shrimp Scampi","Red Lobster",240,17,3,17,0),
                ("Zebra Popcorn","Popcornopolis",280,2,40,14,0);
            """

            try executeSQLStatement(dropTableString)
            try executeSQLStatement(createTableString)
            try executeSQLStatement(populateTableString)
        }

    // MARK: - Query DB
    
        private func executeSQLStatement(_ sql: String) throws {
            guard sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                throw DatabaseError.statementStepFailed("Error executing SQL statement: \(errmsg)")
            }
        }
   
}
