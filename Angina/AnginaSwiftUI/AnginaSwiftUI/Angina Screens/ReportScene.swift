//
//  ReportScene.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 09/12/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import SwiftUI

struct ReportScene: View {
	
	@State var points : PainPointModel
	
	var filter = Filter()
	var dateRange = DateRange()
	
	func bgColor() -> Color {
		return dateRange.SelectedItems.count > 0 ? .blue : .gray
	}
	
	@State var isOn = false
    var body: some View {
		VStack {
			filter
			dateRange
			Spacer()
			HStack {
				Spacer()
				AnginaButton(systemName: "envelope.circle.fill", iconSize: 48, fgColor: bgColor(), bgColor: .white, offset: CGSize.zero, shadow: .black, shadowSize: 2, enabled: dateRange.SelectedItems.count > 0) {
					print(filter.SelectedItems)
					print(dateRange.SelectedItems)
				}
				Spacer()
				AnginaButton(systemName: "xmark.circle.fill", iconSize: 48, fgColor: .black, bgColor: .white, offset: CGSize.zero, shadow: .black, shadowSize: 2, enabled: true) {
					points.goBack()
				}

				Spacer()
			}
		}
    }
}

struct ReportScene_Previews: PreviewProvider {
    static var previews: some View {
		ReportScene(points: PainPointModel())
    }
}

struct ToggleItem : Identifiable {
	var id: Int
	
	var delegate: ToggleItemSelectedDelegate
	
	var Name : String
	var Text : String
	var Selected : Bool = false {
		didSet {
			if Selected {
				delegate.setAsSelected(id: id)
			}
		}
	}
	var AllowMultiSelect : Bool = false
}

protocol ToggleItemSelectedDelegate {
	func setAsSelected(id: Int)
}

class RadioListClass : ToggleItemSelectedDelegate, ObservableObject {

	func setAsSelected(id: Int) {
		for i in 0..<items.count {
			if i != id {
				if !items[i].AllowMultiSelect {
					items[i].Selected = false
				}
			}
		}
		
	}
	
	@Published var items : [ToggleItem] = []
	
	init() {
//		items.append(ToggleItem(id: 0, delegate: self, Name: "ALL", Text: "For all time"))
//		items.append(ToggleItem(id: 1, delegate: self, Name: "24", Text: "Past 24 hours"))
//		items.append(ToggleItem(id: 2, delegate: self, Name: "7", Text: "Past week"))
//		items.append(ToggleItem(id: 3, delegate: self, Name: "14", Text: "Past fortnight"))
//		items.append(ToggleItem(id: 4, delegate: self, Name: "MM", Text: "Past month"))
//		items.append(ToggleItem(id: 5, delegate: self, Name: "YY", Text: "Past year"))
	}
	
	func addItem(_ name: String, text: String, multi: Bool = false, selected: Bool = false) {
		items.append(ToggleItem(id: items.count, delegate: self, Name: name, Text: text, Selected: selected, AllowMultiSelect: multi))
	}

}

struct DateRange: View {
	
	init() {
		dateRangeHandler.addItem("ALL", text: "For all time")
		dateRangeHandler.addItem("24", text: "Past 24 hours")
		dateRangeHandler.addItem("7", text: "Past week")
		dateRangeHandler.addItem("14", text: "Past fortnight")
		dateRangeHandler.addItem("MM", text: "Past month")
		dateRangeHandler.addItem("YY", text: "Past year")
	}
	
	public var SelectedItems : [String] {
		get {
			return dateRangeHandler.items.filter { $0.Selected }.map { $0.Name }
		}
	}
	
	@ObservedObject var dateRangeHandler = RadioListClass()
	

	var body: some View {
		
		VStack(alignment: .leading) {
			Headline(text: "Date Range")
			
			ForEach(0..<dateRangeHandler.items.count, id: \.self) {
				index in
				let item = dateRangeHandler.items[index]
				Toggle(item.Text, isOn: $dateRangeHandler.items[index].Selected)
					.padding([.leading, .trailing], 32.0)
			}
			Spacer()
				
		}
	}
}


struct Filter: View {
	
	var SelectedItems : [String] {
		get {
			return filterHandler.items.filter { $0.Selected }.map { $0.Name	}
		}
	}
	
	init() {
		filterHandler.addItem("TW", text: "Twinges", multi: true, selected: true)
		filterHandler.addItem("BP", text: "Blood Pressure", multi: true, selected: true)
		filterHandler.addItem("ME", text: "Medications", multi: true, selected: true)
		filterHandler.addItem("FD", text: "Food", multi: true, selected: true)
		filterHandler.addItem("MD", text: "Mood", multi: true, selected: true)
		filterHandler.addItem("NT", text: "Notes", multi: true, selected: false)
		
	}
	
	@ObservedObject var filterHandler = RadioListClass()
	
	
	var body: some View {
		
		VStack(alignment: .leading) {
			Headline(text: "Filter")
			
			ForEach(0..<filterHandler.items.count, id: \.self) {
				index in
				let item = filterHandler.items[index]
				if #available(iOS 14.0, *) {
					Toggle(item.Text, isOn: $filterHandler.items[index].Selected)
						.padding([.leading, .trailing], 32.0)
						.toggleStyle(SwitchToggleStyle(tint: .accentColor))
				} else {
					// Fallback on earlier versions
					Toggle(item.Text, isOn: $filterHandler.items[index].Selected)
						.padding([.leading, .trailing], 32.0)
				}
			}
			Spacer()
			
		}
	}
}

struct Headline: View {
	var text: String
	var minHeight: CGFloat = CGFloat(24)
	var body: some View {
		Text(text)
			.multilineTextAlignment(.leading)
			.frame(minWidth: 0, maxWidth: .infinity, minHeight: minHeight, maxHeight: .none, alignment: .topLeading)
			.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
			.background(Color.gray)
	}
}
