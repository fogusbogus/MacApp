//
//  Angina.Additional.Meds.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 04/01/2021.
//  Copyright © 2021 Matt Hogg. All rights reserved.
//

import SwiftUI

class AD_Medications : AdditionalBase {
	
	var am : Bool = false {
		didSet {
			update.toggle()
		}
	}
	
	var pm : Bool = false {
		didSet {
			update.toggle()
		}
	}
	
	var spray : Bool = false {
		didSet {
			update.toggle()
		}
	}
	
	override var canUpdate: Bool {
		get {
			return am || pm || spray
		}
	}
	
	override func reset() {
		am = false
		pm = false
		spray = false
	}

	override func getSaveData() -> [String : Any] {
		var ret : [String:Any] = [:]
		let dt = Date().toISOString()
		if canUpdate {
			if am {
				ret["am"] = dt
			}
			if pm {
				ret["pm"] = dt
			}
			if spray {
				ret["spray"] = dt
			}
		}
		return collectSaveData("meds", data: ret)

	}
}

struct Medications: View {
	
	@ObservedObject var data : AD_Medications
	
	var body : some View {
		VStack(spacing: 24) {
			Headline(text: "Medications")
			HStack(spacing: 24) {
				GlowButton(text: "AM", action: {
					data.am.toggle()
				}, allowed: data.am)
				GlowButton(text: "PM", action: {
					data.pm.toggle()
				}, allowed: data.pm)
				GlowButton(text: "Spray", action: {
					data.spray.toggle()
				}, allowed: data.spray)
				.padding(.leading, 24)
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

struct Angina_Additional_Meds: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct Angina_Additional_Meds_Previews: PreviewProvider {
    static var previews: some View {
        Angina_Additional_Meds()
    }
}
