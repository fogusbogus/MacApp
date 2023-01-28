//
//  ResultWithResult.swift
//  MCResults
//
//  Created by Matt Hogg on 28/01/2023.
//

import SwiftUI
import MeasuringView

struct ResultWithResult: View {
	
	@ObservedObject private var measures = MeasuringView()
	
    var body: some View {
		ZStack {
			ResultValue.good.resizableImage
				.decidesHeightOf(measures, key: "H")
				.decidesWidthOf(measures, key: "W")
			Circle()
				.foregroundColor(.white)
				.offset(x: measures["W"].width / 3, y: measures["H"].height / 3)
				.frame(width: 16, height: 16)
			ResultValue.warning.resizableImage.frame(width: 16, height: 16).offset(x: 16, y: 16)
		}
    }
}

struct ResultWithResult_Previews: PreviewProvider {
    static var previews: some View {
        ResultWithResult()
			.frame(width: 48, height: 48)
    }
}
