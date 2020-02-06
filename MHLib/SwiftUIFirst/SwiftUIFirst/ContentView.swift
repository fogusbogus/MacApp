//
//  ContentView.swift
//  SwiftUIFirst
//
//  Created by Matt Hogg on 06/01/2020.
//  Copyright © 2020 Matthew Hogg. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		HSplitView(content: {
			Text("Hello, World!")
				.frame(maxWidth: .infinity, maxHeight: .infinity)

		})
	}
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
