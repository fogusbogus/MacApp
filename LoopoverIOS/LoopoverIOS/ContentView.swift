//
//  ContentView.swift
//  LoopoverIOS
//
//  Created by Matt Hogg on 03/01/2023.
//

import SwiftUI

struct ContentView: View {
	
	@State var loop = LoopoverCanvas()
	
    var body: some View {
        
			Canvas(renderer: loop.render)
        
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
