//
//  PropertyListItem.swift
//  Canvasser
//
//  Created by Matt Hogg on 29/01/2021.
//

import SwiftUI

class PropertyListItemData {
	var Name : String
	var TODO : String = ""
	var GPS  : String = ""
	var Complete : Bool = false
	
	init(name: String, todo: String = "", gps: String = "", complete: Bool = false) {
		self.Name = name
		self.TODO = todo
		self.GPS = gps
		self.Complete = complete
	}
}

struct PropertyListItem: View {
	
	@State var data : PropertyListItemData
	
	func iconColor() -> Color {
		let todo = data.TODO.trimmingCharacters(in: .whitespacesAndNewlines)
		if todo != "" {
			return data.Complete ? Color.green : Color.purple
		}
		return Color(UIColor.tertiaryLabel)
	}
	
	func gpsIconName() -> String {
		if data.GPS.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
			return ""
		}
		return "mappin"
	}
	
	var body: some View {
		VStack {
			//Icon
			HStack(alignment: .top, spacing: 24, content: {
				Image(systemName: "house.fill")
					.resizable()
					.scaledToFit()
					.frame(width: 48, height: 48, alignment: .center)
					.aspectRatio(contentMode: .fill)
					.foregroundColor(iconColor())
				//Name and subtext
				VStack(alignment: .leading, spacing: 8, content: {
					Text(data.Name)
						.font(.system(.title))
					Text(data.TODO)
						.italic()
				})
				Spacer()
				
				//GPS
				if gpsIconName() != "" {
					VStack(alignment: .center, spacing: 8, content: {
						Image(systemName: gpsIconName())
							.resizable()
							.scaledToFit()
							.frame(width: 32, height: 32, alignment: .center)
							.aspectRatio(contentMode: .fill)
						
						Text(data.GPS)
							.font(.system(.subheadline))
					})
					.frame(minWidth: 100)
				}
			})
			
		}
		.padding([.leading, .trailing], 24)
	}
}


struct PropertyListItem_Previews: PreviewProvider {
    static var previews: some View {
		PropertyListItem(data: PropertyListItemData(name: "11, Berkeley Close", todo: "5 electors\n2 x ITR", gps: "145.4m", complete: true))
			.preferredColorScheme(.dark)
    }
}
