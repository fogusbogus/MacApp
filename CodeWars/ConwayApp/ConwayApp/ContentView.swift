//
//  ContentView.swift
//  ConwayApp
//
//  Created by Matt Hogg on 29/09/2022.
//

import SwiftUI

struct ContentView: View {
	
	@ObservedObject var cellArray: CellArray2
	
	let timer = Timer.publish(every: 0.025, on: .main, in: .common).autoconnect()

	private var cells : [[Int]] {
		get {
			return cellArray.render()
		}
	}
	
    var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			ForEach(0..<cells.count, id:\.self) { y in
				let line = cells[y]
				HStack(alignment: .top, spacing: 0) {
					ForEach(0..<line.count, id:\.self) { x in
						let cell = line[x]
						Image("")
							.frame(width:4, height: 4)
							.background(cell == 1 ? .white : .black)
							.onTapGesture {
								if cell == 0 {
									cellArray.setCell(x: x, y: y, 1)
									cellArray.setCell(x: x+1, y: y, 1)
									cellArray.setCell(x: x, y: y+1, 1)
								}
							}
					}
				}
			}
        }
        .padding()
		.onReceive(timer) { input in
			cellArray.process()
		}
		
    }
}

struct ContentView_Previews: PreviewProvider {
	static var cellArray = CellArray2(cells: [[1,0,0],
											 [0,1,1],
											 [1,1,0]])
    static var previews: some View {
        ContentView(cellArray: cellArray)
    }
}
