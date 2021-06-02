//
//  NavBar.swift
//  Canvasser
//
//  Created by Matt Hogg on 17/01/2021.
//

import SwiftUI
import CoreData

class NavBarData : ObservableObject {
	
	@Published var update : Bool = false
	
	var delegate: NavBarDataDelegate? = nil
	
	var history : [(String, String)] = []
	
	var canGoBack : Bool {
		get {
			return history.count > 0
		}
	}
	

	var canGoHome : Bool {
		get {
			return history.count > 0
		}
	}
	
	func goBack() {
		if canGoBack {
			_ = history.popLast()
		}
		delegate?.show()
		update.toggle()
	}
	
	func goHome() {
		reset()
		delegate?.show()
		update.toggle()
	}
	
	var canShowMap : Bool = false
	
	func navigateTo(_ newHistoryItem: (String,String)) {
		if history.count == 0 {
			history.append(newHistoryItem)
			update.toggle()
		}
		else {
			if history.last?.0 != newHistoryItem.0 {
				history.append(newHistoryItem)
				update.toggle()
			}
		}
	}
	
	var currentTitle: String {
		get {
			if history.count == 0 {
				return "Roads"
			}
			return history.last!.1
		}
	}
	
	var currentKey: String {
		get {
			if history.count > 0 {
				return history.last!.0
			}
			return ""
		}
	}
	
	func reset() {
		history.removeAll()
		update.toggle()
	}
}

protocol NavBarDataDelegate {
	func show()
}

struct NavBar: View {
	
	enum NavAction {
		case back, showOnMap, home
	}
	
	@State var clickDelegate: ((Self, NavAction) -> Void)?
	@ObservedObject var data : NavBarData
	
    var body: some View {
		GeometryReader { geo in
			HStack(alignment: .center, spacing: Resizer.iconSize(geo.size.width)) {
				Button(action: {
					clickDelegate?(self, .back)
					//clickDelegate?(self, .back)
				}, label: {
					Image(systemName: "arrow.backward")
						.resizable()
						.frame(width: Resizer.iconSize(geo.size.width), height: Resizer.iconSize(geo.size.width), alignment: .center)
						.foregroundColor(textColor(data.canGoBack))
						.disabled(!(data.canGoBack ?? false))
				})
				
				Button(action: {
					clickDelegate?(self, .showOnMap)
				}, label: {
					Image(systemName: "mappin.and.ellipse")
						.resizable()
						.frame(width: Resizer.iconSize(geo.size.width), height: Resizer.iconSize(geo.size.width), alignment: .center)
						.foregroundColor(textColor(data.canShowMap ?? false))
						.disabled(!(data.canShowMap ?? false))
				})
				Text(data.currentTitle ?? "No data")
					.bold()
					.foregroundColor(Color("TitleEnabledIcon"))
					.font(.system(size: Resizer.iconSize(geo.size.width) * 0.75))
					.frame(maxWidth: .infinity)
				Button(action: {
					clickDelegate?(self, .home)
				}, label: {
					Image(systemName: "house.fill")
						.resizable()
						.frame(width: Resizer.iconSize(geo.size.width), height: Resizer.iconSize(geo.size.width), alignment: .center)
						.foregroundColor(textColor(data.canGoHome ?? false))
						.disabled(!(data.canGoHome ?? false))
				})
			}
			.padding()
			.background(LinearGradient(gradient: Gradient(colors: [Color("CanvasserGreen"), Color("CanvasserGreenLight")]), startPoint: .top, endPoint: .bottom))
		}
    }
}

/*
Image(systemName: "exclamationmark.triangle.fill")
.resizable()
.frame(width: Resizer.iconSize(geo.size.width), height: Resizer.iconSize(geo.size.width), alignment: .center)
.foregroundColor(Color("TitleEnabledIcon"))
*/

struct NavBar_Previews: PreviewProvider {
	
	static var _data : NavBarData? = nil
	static var data : NavBarData {
		get {
			if _data == nil {
				_data = NavBarData()
				_data?.navigateTo(("ST132", "Berkeley Close"))
			}
			return _data!
		}
	}
	
    static var previews: some View {
		NavBar(clickDelegate: { (nb, action) in
			if action == .back {
				data.goBack()
			}
		}, data: data)
    }
}
