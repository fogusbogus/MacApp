//
//  ElectorListItem.swift
//  Canvasser
//
//  Created by Matt Hogg on 29/01/2021.
//

import SwiftUI

class ElectorListItemData {
	
	init(name: String, todo : String = "", nationality: String = "British", pv : Bool = false, over76 : Bool = false, complete: Bool = false) {
		self.Name = name
		self.TODO = todo
		self.Nationality = nationality
		self.PV = pv
		self.Over76 = over76
		self.Complete = complete
	}
	
	var Name : String
	var TODO : String = ""
	var Nationality : String = "British"
	
	var PV : Bool = true
	var Over76 : Bool = false
	var Complete : Bool = false
}

struct ElectorListItem: View {
	
	@State var data : ElectorListItemData
	
	func flagFG(_ truth: Bool) -> Color {
		return truth ? Color(UIColor.systemBackground) : Color(UIColor.tertiaryLabel)
	}
	func flagBG(_ truth: Bool) -> Color {
		return truth ? Color(UIColor.label) : Color(UIColor.systemBackground)
	}
	
	func iconColor() -> Color {
		let todo = data.TODO.trimmingCharacters(in: .whitespacesAndNewlines)
		if todo != "" {
			return data.Complete ? Color.green : Color.purple
		}
		return Color(UIColor.tertiaryLabel)
	}

	var body: some View {
		VStack {
			//Icon
			HStack(alignment: .top, spacing: 24, content: {
				Image(systemName: "person.fill")
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
				//Flags
				HStack(alignment: .top, spacing: 8, content: {
					Text(data.Nationality)
						.font(.system(.title))
					Text("PV")
						.font(.system(.headline))
						.bold()
						.padding(8)
						.foregroundColor(flagFG(data.PV))
						.background(flagBG(data.PV))
						.border(Color.primary, width: 1)
					Text("76")
						.font(.system(.headline))
						.bold()
						.padding(8)
						.foregroundColor(flagFG(data.Over76))
						.background(flagBG(data.Over76))
						.border(Color.primary, width: 1)
					
				})
				
			})
			
		}
		.padding([.leading, .trailing], 24)
	}
}

struct ElectorListItem_Previews: PreviewProvider {
    static var previews: some View {
		ElectorListItem(data: ElectorListItemData(name: "Fred Flintstone", todo: "ITR", nationality: "American", pv: false, over76: true, complete: false))
			.preferredColorScheme(.light)
    }
}
