//
//  RecordDescriptor.swift
//  MCResults
//
//  Created by Matt Hogg on 25/01/2023.
//

import SwiftUI

struct RecordDescriptor<Content: View>: View {
	var title: String = "TITLE"
	
	var content : () -> Content
	
    var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text(title)
				.styling(.verbatimDataHeading)
			HStack(alignment: .top, spacing: 0) {
				VStack(alignment: .leading, spacing: 16) {
					Rectangle()
						.frame(height: 2)
						.frame(maxWidth: 150)
					Group(content: content)
						.styling(.verbatimData)
				}
				Spacer()
			}
			.padding()
			.background(Color("RecordDescriptor/Back"))
			.foregroundColor(Color("RecordDescriptor/Fore"))
		}
    }
}

struct RecordDescriptor_Previews: PreviewProvider {
    static var previews: some View {
		RecordDescriptor(title: "RECORD") {
			Text("Some text")
		}
		.padding()
    }
}
