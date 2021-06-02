//
//  TitleBar.swift
//  Canvasser
//
//  Created by Matt Hogg on 16/01/2021.
//

import SwiftUI

class Resizer {
	class func iconSize(_ size: CGFloat) -> CGFloat {
		return 0.06 * size
	}
}

class TitleBarData : ObservableObject {
	@Published var update : Bool = false
	
	var downloading: Bool = false {
		didSet {
			update.toggle()
		}
	}
}

extension View {
	func textColor(_ enabled: Bool) -> Color {
		return enabled ? Color("TitleEnabledIcon") : Color("TitleDisabledIcon")
	}
}

struct TitleBar: View {
	
	@State var data : TitleBarData? = nil
	
	@State var delegate: ((Self, String) -> Void)?
	
	private func iCloudImage() -> String {
		guard data != nil else { return "arrow.clockwise.icloud" }
		return data!.downloading ? "icloud.and.arrow.down" : "icloud.and.arrow.up"
	}
	
	var iconSize: CGFloat = 48
	
    var body: some View {
			HStack(alignment: .center, spacing: iconSize) {
				//Burger
				Button(action: {
					delegate?(self, "settings")
				}, label: {
					Image(systemName: "gear")
						.resizable()
						.frame(width: iconSize, height: iconSize, alignment: .center)
						.scaledToFit()
						.foregroundColor(Color("TitleEnabledIcon"))
				})
				Text("Canvasser")
					.foregroundColor(Color("TitleEnabledIcon"))
					.font(.system(size: iconSize * 0.75))
				Spacer()
				
				//Other icons
				Button(action: {
					delegate?(self, "search")
				}, label: {
					Image(systemName: "magnifyingglass")
						.resizable()
						.frame(width: iconSize, height: iconSize, alignment: .center)
						.scaledToFit()
						.foregroundColor(textColor(true))
				})
				
				Button(action: {
					delegate?(self, "cloud")

				}, label: {
					Image(systemName: iCloudImage())
						.resizable()
						.frame(width: iconSize, height: iconSize, alignment: .center)
						.scaledToFit()
						.foregroundColor(Color("TitleEnabledIcon"))
				})
				
				Button(action: {
					delegate?(self, "filter")

				}, label: {
					Image(systemName: "slider.horizontal.3")
						.resizable()
						.frame(width: iconSize, height: iconSize, alignment: .center)
						.scaledToFit()
						.foregroundColor(Color("TitleEnabledIcon"))
				})
				
				Button(action: {
					delegate?(self, "alert")

				}, label: {
					Image(systemName: "exclamationmark.triangle.fill")
						.resizable()
						.frame(width: iconSize, height: iconSize, alignment: .center)
						.foregroundColor(Color("TitleEnabledIcon"))
				})
			}
			.padding()
			.background(Color("CanvasserGreen"))
    }
}

struct TitleBar_Previews: PreviewProvider {

	
    static var previews: some View {
		TitleBar { (tb, msg) in
			print(msg)
		}
    }
}
