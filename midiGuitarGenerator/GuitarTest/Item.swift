//
//  Item.swift
//  GuitarTest
//
//  Created by Matt Hogg on 09/10/2023.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
