//
//  main.swift
//  SQLiteDB
//
//  Created by Matt Hogg on 09/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import DBLib


print("Hello, World!")

SQLDB.open()
SQLDB.execute("CREATE TABLE SomeData (ID INTEGER, Some TEXT)")
SQLDB.execute("DELETE FROM SomeData")
SQLDB.execute("INSERT INTO SomeData (ID, Some) VALUES (1, 'One')")
SQLDB.execute("INSERT INTO SomeData (ID, Some) VALUES (2, 'Two')")
SQLDB.execute("INSERT INTO SomeData (ID, Some) VALUES (3, 'Three')")
SQLDB.execute("INSERT INTO SomeData (ID, Some) VALUES (4, 'Four')")
SQLDB.execute("INSERT INTO SomeData (ID, Some) VALUES (5, 'Five')")

let txt = "This is a small test to see if the characters in this item stretch beyond the line boundary and then wrap onto the next line. The line length should be variable and amendable."
SQLDB.execute("INSERT INTO SomeData (ID, Some) VALUES (6, '\(txt.sqlSafe())')")

let rows = SQLDB.queryMultiRow("SELECT * FROM SomeData")

let cl = ColList()
cl.fromSQLRowArray(rows)
cl.outputToConsole()
