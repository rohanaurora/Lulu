//
//  Database.swift
//  Lulu
//
//  Created by Rohan Aurora on 9/2/20.
//  Copyright © 2020 Rohan Aurora. All rights reserved.
//

import Foundation
import SQLite3

/// A minimalist SQLite wrapper for Swift.
class Database {
    init() {
        db = openDatabase()
        createTable()
    }
    
    let dbPath: String = "Lulu.sqlite"
    var db:OpaquePointer?
    
    private func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening the database.")
            return nil
        } else {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    private func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS garment(Id INTEGER PRIMARY KEY,name TEXT,date INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("garment table created.")
            } else {
                print("garment table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    internal func insert(id:Int, name:String, date:Int) {
        let garments = read()
        for g in garments {
            if g.itemID == id { return }
        }
        let insertStatementString = "INSERT INTO garment (Id, name, date) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(date))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    internal func read(_ customQuery:String? = nil) -> [Garment] {
        var queryStatementString: String?
        var queryStatement: OpaquePointer? = nil
        var garmentDB : [Garment] = []

        if let q = customQuery, !q.isEmpty {
            queryStatementString = q
        } else {
            queryStatementString = "SELECT * FROM garment ORDER BY LOWER(name);"
        }
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let year = sqlite3_column_int(queryStatement, 2)
                garmentDB.append(Garment(id: Int(id), name: name, date: Int(year)))
                print("\nQuery Result:")
                print("\(id) | \(name) | \(year)")
            }
        } else {
            print("SELECT statement could not be prepared.")
        }
        sqlite3_finalize(queryStatement)
        return garmentDB
    }
    
    internal func deleteAll() {
        let deleteStatementStirng = "DROP TABLE garment;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted table.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    internal func sortBy(state: OrderState? = nil) -> [Garment] {
        if state == .date {
            let orderQuery = "SELECT * FROM garment ORDER BY date DESC;"
            return read(orderQuery)
        } else {
            return read()
        }
    }
}
