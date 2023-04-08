//
//  ContentView.swift
//  CanvasTest
//
//  Created by Matt Hogg on 01/04/2023.
//

import SwiftUI
import AppKit

struct ContentView: View {
	
	var img = Image("Diamond")
	
    var body: some View {
        VStack {
			Canvas { context, size in
				let rect = CGRect(origin: context.clipBoundingRect.origin, size: CGSize(width: 48, height: 48))
				
				context.draw(img, in: rect)
			}
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
