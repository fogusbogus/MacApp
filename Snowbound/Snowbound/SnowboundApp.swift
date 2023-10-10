//
//  SnowboundApp.swift
//  Snowbound
//
//  Created by Matt Hogg on 27/11/2022.
//

import SwiftUI

@main
struct SnowboundApp: App {
	
	var snow: Snow = Snow(noFlakes: 500)
	
    var body: some Scene {
        WindowGroup {
			ContentView(snow: snow)
        }
    }
}
