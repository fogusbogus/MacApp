//
//  ListItem.swift
//  Canvasser
//
//  Created by Matt Hogg on 29/01/2021.
//

import SwiftUI

struct ListItem: View {
	var body: some View {
		VStack {
			//Icon
			HStack(alignment: .top, spacing: 24, content: {
				Image(systemName: "person.fill")
					.resizable()
					.scaledToFit()
					.frame(width: 48, height: 48, alignment: .center)
					.aspectRatio(contentMode: .fill)
				//Name and subtext
				VStack {
					Text("Fred Flintstone")
						.font(.system(.title))
					Text("2 properties complete")
				}
				Spacer()
				//Flags
				HStack(alignment: .top, spacing: 8, content: {
					Text("Australian")
						.font(.system(.title))
					Text("PV")
						.font(.system(.headline))
						.padding(8)
						.border(Color.white, width: 1)
					Text("76")
						.font(.system(.headline))
						.padding(8)
						.border(Color.white, width: 1)

				})
				//GPS
				VStack(alignment: .center, spacing: 8, content: {
					Image(systemName: "mappin")
						.resizable()
						.scaledToFit()
						.frame(width: 32, height: 32, alignment: .center)
						.aspectRatio(contentMode: .fill)
					Text("No GPS")
						.font(.system(.subheadline))
				})
					
			})

		}
		.padding([.leading, .trailing], 24)
	}
}

struct ListItem_Previews: PreviewProvider {
	static var previews: some View {
		ListItem()
			.preferredColorScheme(.dark)
	}
}
