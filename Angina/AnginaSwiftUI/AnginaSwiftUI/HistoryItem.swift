//
//  HistoryItem.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 14/12/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import SwiftUI

struct HistoryItem: View {
	
	var data = HistoryItemData(isRedo: false, isUndo: false, displayCode: "MSG", displayCodeDescription: "This is a message", staffName: "Matt Hogg", ts: Date())
	
	
	var undoRedoImage : String {
		get {
			if data.isRedo {
				return "arrow.uturn.forward"
			}
			else {
				if data.isUndo {
					return "arrow.uturn.backward"
				}
				else {
					return "message"
				}
			}
		}
	}
	
    var body: some View {
		HStack(alignment: .top) {
			//Icon
			Image(systemName: undoRedoImage)
				.resizable(resizingMode: .stretch)
				.aspectRatio(contentMode: .fit)
				.padding(.top, 12.0)
				.frame(width: 29, height: 128, alignment: .top)
			VStack {
				HStack(alignment: .top) {
					Text("\(data.displayCode) - \(data.displayCodeDescription)")
						.font(.headline)
					HStack {
						//1.4
						Text(data.staffName)
							.font(.system(.footnote))
							.foregroundColor(Color(.sRGB, red: 0x44, green: 0x44, blue: 0x44, opacity: 0xff))
						Text("")
							.frame(width: 14, height: 14, alignment: .center)
						Text(data.ts.absoluteDate().toString("dd/MM/yy"))
							.font(.system(.footnote))
							
						Text("")
							.frame(width: 14, height: 14, alignment: .center)
						Text(data.ts.toString("HH:mm"))
							.font(.system(.footnote))
							.foregroundColor(Color(.sRGB, red: 0x44, green: 0x44, blue: 0x44, opacity: 0xff))

					}
					.padding(.trailing, 12)
				}
				.padding(12)
			}
			.padding(.leading, 20)
			.padding(.top, 3)
		}
		.onTapGesture {
			
		}
    }
}

struct HistoryItemData {
	var isRedo : Bool
	var isUndo : Bool
	var displayCode : String
	var displayCodeDescription : String
	var staffName : String
	var ts : Date
}

struct HistoryItem_Previews: PreviewProvider {
    static var previews: some View {
        HistoryItem()
    }
}
