//
//  ConwayAppApp.swift
//  ConwayApp
//
//  Created by Matt Hogg on 29/09/2022.
//

import SwiftUI

@main
struct ConwayAppApp: App {
	
	private var cells = CellArray2(cells: [[1,0,0],
										  [0,1,1],
										  [1,1,0]])

	
    var body: some Scene {
        WindowGroup {
			ContentView(cellArray: cells)
        }
    }
}
