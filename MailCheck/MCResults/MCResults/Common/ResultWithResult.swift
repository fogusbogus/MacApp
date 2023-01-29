//
//  ResultWithResult.swift
//  MCResults
//
//  Created by Matt Hogg on 28/01/2023.
//

import SwiftUI
import MeasuringView

struct ResultWithResult: View {

	private let divider : CGFloat = 0.3333
	
	@ObservedObject private var measures = MeasuringView()
	
	var caveat: ResultValue = .warning
	
	private var shadowRadius: CGFloat {
		get {
			if let sz = measures.get("W") {
				return CGFloat(sz.width * divider)
			}
			return 8
		}
	}
	
    var body: some View {
		ZStack {
			ResultValue.good.resizableImage
				.decidesHeightOf(measures, key: "H")
				.decidesWidthOf(measures, key: "W")
			Circle()
				.foregroundColor(.white)
				.offsetByWidth(measures, key: "W", multiplier: divider)
				.offsetByHeight(measures, key: "H", multiplier: divider)
				.followsWidthOf(measures, key: "W", multiplier: divider)
				.followsHeightOf(measures, key: "H", multiplier: divider)
				.shadow(radius: shadowRadius)
			caveat.resizableImage
				.offsetByWidth(measures, key: "W", multiplier: divider)
				.offsetByHeight(measures, key: "H", multiplier: divider)
				.followsWidthOf(measures, key: "W", multiplier: divider)
				.followsHeightOf(measures, key: "H", multiplier: divider)
		}
    }
}

struct ResultWithResult_Previews: PreviewProvider {
    static var previews: some View {
		ResultWithResult(caveat: .unknown)
			.frame(width: 128, height: 128)
    }
}
