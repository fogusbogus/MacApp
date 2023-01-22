//
//  ListTest.swift
//  MCResults
//
//  Created by Matt Hogg on 12/01/2023.
//

import SwiftUI
import MeasuringView

struct ResultsView<T>: View where T : Identifiable {
	
	struct Header : Identifiable {
		var id: String
	}
	
	var results: [T] = []
	var headers: [String] = []
	var blankRowsAtEnd: Int = 2
	
	func getHeaders() -> [Header] {
		return headers.map({Header(id: $0)})
	}
	
	var altGetDataItem: (T, String, MeasuringView) -> AnyView
	
	@State private var listSize = CGSize.zero
	@ObservedObject private var measures = MeasuringView()
	
    var body: some View {

		VStack {
			Color.clear
				.frame(height: 0)
				.decidesWidthOf(measures, key: "WIDTH")
				
			Grid(alignment: .topLeading, horizontalSpacing: 8, verticalSpacing: 8, content: {
				//Do the headers first
				GridRow {
					ForEach(getHeaders()) { header in
						Text(header.id)
							.styling(.resultTableHeading)
					}
				}
				.padding(.bottom, 4)
				ForEach(results) { result in
					GridRow {
						ForEach(getHeaders()) { header in
							altGetDataItem(result, header.id, measures)
						}
					}
				}
				ForEach((0..<blankRowsAtEnd), id:\.self) { _ in
					GridRow {
						Text("")
					}
				}
			})
		}
		//.decidesHeightOf(measures, key: "HEIGHT")
    }
}

struct ListTest_Previews: PreviewProvider {
	
	static var data: [SPFTestResult] = [
		SPFTestResult(id: 0, name: "Is there a single SPF record?", result: ResultValue.good),
		SPFTestResult(id: 1, name: "Are the tags and values used valid?", result: ResultValue.good),
		SPFTestResult(id: 2, name: "Is there a strong ending to the SPF record (i.e. -all or ~all)", result: ResultValue.good),
		SPFTestResult(id: 3, name: "Are the referenced records free of syntax issues", result: ResultValue.warning),
		SPFTestResult(id: 4, name: "Do all the lookups to other DNS records work?", result: ResultValue.good),
		SPFTestResult(id: 5, name: "Is the number of DNS lookups under the limit of 10?", result: ResultValue.bad),
		SPFTestResult(id: 7, name: "Extends over more than one line; Extends over more than one line; Extends over more than one line; Extends over more than one line; ", result: ResultValue.good)
	]
    static var previews: some View {
		VStack {
			ResultsView(results: data, headers: ["Test", "Result"], blankRowsAtEnd: 2) { res, header, measures in
				switch header {
					case "Test":
						return AnyView(
							Text(res.name)
								.followsWidthOf(measures, key: "WIDTH", alignment: .leading, multiplier: 0.8)
						)
						
					default:
						return AnyView(
							HStack(alignment: .center, spacing: 8) {
								res.result.image
								Text(res.result.passText)
							}
						)
				}

			}
			Text("This is some text")
			Spacer()
		}
    }
}
