//
//  main.swift
//  Kata
//
//  Created by Matt Hogg on 08/01/2023.
//

import Foundation

let cypher = CaesarCypherII()

let u = "I should have known that you would have a perfect answer for me!!!"
let j = cypher.encode(u, 1)
print(cypher.decode(j))
