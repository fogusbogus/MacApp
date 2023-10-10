//
//  Angina.Additional.Food.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 04/01/2021.
//  Copyright © 2021 Matt Hogg. All rights reserved.
//

import SwiftUI

class AD_Food : AdditionalBase {
	
	enum FoodType {
		case none, small, medium, large
	}
	
	var type : FoodType = .none {
		didSet {
			update.toggle()
		}
	}
	
	override var canUpdate: Bool {
		get {
			return type != .none
		}
	}
	
	override func reset() {
		type = .none
	}
	
	override func getSaveData() -> [String : Any] {
		if canUpdate {
			let dt = Date().toISOString()
			return collectSaveData("food", data: ["\(type)":dt])
		}
		return [:]
	}

}

struct Food: View {
	
	@ObservedObject var data : AD_Food
	
	var body : some View {
		VStack(spacing: 24) {
			Headline(text: "Food")
			HStack(spacing: 24) {
				GlowButton(text: "Small", action: {
					if data.type != AD_Food.FoodType.small {
						data.type = AD_Food.FoodType.small
					}
					else {
						data.type = AD_Food.FoodType.none
					}
				}, allowed: data.type == AD_Food.FoodType.small)
				GlowButton(text: "Medium", action: {
					if data.type != AD_Food.FoodType.medium {
						data.type = AD_Food.FoodType.medium
					}
					else {
						data.type = AD_Food.FoodType.none
					}
				}, allowed: data.type == AD_Food.FoodType.medium)
				GlowButton(text: "Large", action: {
					if data.type != AD_Food.FoodType.large {
						data.type = AD_Food.FoodType.large
					}
					else {
						data.type = AD_Food.FoodType.none
					}
				}, allowed: data.type == AD_Food.FoodType.large)
				Spacer()
			}
			.padding([.leading, .trailing], 24)
			UpdateLine(action: {
				print(data.getSaveData())
				data.reset()
			}, allowed: data.canUpdate)
		}
	}
}

struct Angina_Additional_Food: View {
	var body: some View {
		Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
	}
}

struct Angina_Additional_Food_Previews: PreviewProvider {
	static var previews: some View {
		Angina_Additional_Food()
	}
}
