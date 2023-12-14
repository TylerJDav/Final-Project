//
//  ShoppingListManager.swift
//  Final Project
//
//  Created by Tyler Davidson on 12/13/23.
//

import Foundation
import SQLite3

class ShoppingListManager {
    private let db: OpaquePointer? = DatabaseManager.shared?.db

    // MARK: - Create Item

    func addItem(name: String, quantity: Int) throws {
        let queryString = "INSERT INTO ShoppingItems (ItemName, Quantity) VALUES (?, ?)"

        var stmt: OpaquePointer?

        guard sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) == SQLITE_OK else {
            throw DatabaseError.statementPrepareFailed("Error preparing insert statement")
        }

        defer {
            sqlite3_finalize(stmt)
        }

        guard sqlite3_bind_text(stmt, 1, name, -1, nil) == SQLITE_OK,
              sqlite3_bind_int(stmt, 2, Int32(quantity)) == SQLITE_OK else {
            throw DatabaseError.statementBindFailed("Error binding values to insert statement")
        }

        guard sqlite3_step(stmt) == SQLITE_DONE else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            throw DatabaseError.statementStepFailed("Error inserting item: \(errmsg)")
        }
    }

    // MARK: - Read Item

    func readItem(withId id: Int) -> (name: String, quantity: Int)? {
        let queryString = "SELECT * FROM ShoppingItems WHERE ID = ?"

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
        let quantity = Int(sqlite3_column_int(stmt, 2))

        return (name, quantity)
    }

    // MARK: - Update Item

    func updateItem(id: Int, name: String, quantity: Int) throws {
        let queryString = "UPDATE ShoppingItems SET ItemName = ?, Quantity = ? WHERE ID = ?"

        var stmt: OpaquePointer?

        guard sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) == SQLITE_OK else {
            throw DatabaseError.statementPrepareFailed("Error preparing update statement")
        }

        defer {
            sqlite3_finalize(stmt)
        }

        guard sqlite3_bind_text(stmt, 1, name, -1, nil) == SQLITE_OK,
              sqlite3_bind_int(stmt, 2, Int32(quantity)) == SQLITE_OK,
              sqlite3_bind_int(stmt, 3, Int32(id)) == SQLITE_OK else {
            throw DatabaseError.statementBindFailed("Error binding values to update statement")
        }

        guard sqlite3_step(stmt) == SQLITE_DONE else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            throw DatabaseError.statementStepFailed("Error updating item: \(errmsg)")
        }
    }

    // MARK: - Delete Item

    func deleteItem(withId id: Int) throws {
        let queryString = "DELETE FROM ShoppingItems WHERE ID = ?"

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
        let clearTableString = "DELETE FROM ShoppingItems"

        if sqlite3_exec(db, clearTableString, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            throw DatabaseError.statementStepFailed("Error clearing database: \(errmsg)")
        }
    }

    // MARK: - Reset Database

    func resetDatabase() throws {
        let dropTableString = "DROP TABLE IF EXISTS ShoppingItems"
        let createTableString = """
            CREATE TABLE IF NOT EXISTS ShoppingItems (
                ID INTEGER PRIMARY KEY AUTOINCREMENT,
                ItemName TEXT NOT NULL,
                Quantity INTEGER
            );
        """
        // You can customize the initial items as needed
        let populateTableString = """
            INSERT INTO ShoppingItems
            (ItemName, Quantity)
            VALUES
            ("Milk", 1),
            ("Bread", 1),
            ("Eggs", 1);
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
