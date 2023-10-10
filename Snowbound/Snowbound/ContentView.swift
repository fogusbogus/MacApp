//
//  ContentView.swift
//  Snowbound
//
//  Created by Matt Hogg on 27/11/2022.
//

import SwiftUI

struct ContentView: View {

	@ObservedObject var snow: Snow
	let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
	
    var body: some View {
		Group {
			Canvas { context, size in
				snow.drawToCanvas(context: context, size: size)
			}
			.overlay {
//				Text("This is a test")
//					.foregroundColor(.blue)
//					.fontWidth(.expanded)
//					.bold()
				///Put something in here!
			}
		}
		.onReceive(timer) { _ in
			snow.move()
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView(snow: Snow())
    }
}
