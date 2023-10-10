//
//  Parent.swift
//  AWSTwingeIntegration
//
//  Created by Matt Hogg on 03/01/2021.
//  Copyright © 2021 Matthew Hogg. All rights reserved.
//

import SwiftUI

struct Parent: View {
	var test : String {
		get {
			let bp = ADBloodPressure(systolic: 135, diastolic: 85)
			return bp.encodeJson()
		}
	}
	var body: some View {
		HStack {
			Text(test)
		}
	}
}

struct Parent_Previews: PreviewProvider {
	static var previews: some View {
		Parent()
	}
}
