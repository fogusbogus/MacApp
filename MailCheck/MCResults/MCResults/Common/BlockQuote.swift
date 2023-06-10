//
//  BlockQuote.swift
//  MCResults
//
//  Created by Matt Hogg on 25/01/2023.
//

import SwiftUI
import MeasuringView

struct BlockQuote<Content: View>: View {
	
	@ObservedObject private var measure = MeasuringView()
	
	var backColor = Color("Blockquote/Back")
	var barColor = Color("Blockquote/Bar")
	var foreColor = Color("Blockquote/Fore")
	
	var content: () -> Content
    var body: some View {
		HStack(alignment: .center, spacing: 16) {
			Rectangle()
				.followsHeightOf(measure, key: "HEIGHT")
				.frame(width: 4)
				.foregroundColor(barColor)
			Group(content: content)
				.padding([.top, .bottom], 8)
				.decidesHeightOf(measure, key: "HEIGHT")
			Spacer()
		}
		.foregroundColor(foreColor)
		.background(backColor)
    }
}

struct BlockQuoted_Previews: PreviewProvider {
    static var previews: some View {
		BlockQuote(backColor: Color("Blockquote/DMARC/Back"), barColor: Color("Blockquote/DMARC/Bar"), foreColor: Color("Blockquote/DMARC/Fore")) {
			Text("DMARC well configured.")
		}
		.padding()
    }
}
