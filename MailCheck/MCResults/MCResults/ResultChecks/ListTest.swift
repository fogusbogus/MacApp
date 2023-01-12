//
//  ListTest.swift
//  MCResults
//
//  Created by Matt Hogg on 12/01/2023.
//

import SwiftUI

struct ListTest: View {
	
	var results: [SPFTestResult] = []
	
	@State var listSize = CGSize.zero
	
	func getResults() -> [SPFTestResult] {
		var ret = results
		ret.insert(SPFTestResult(id: -1, name: "", result: ResultValue.good), at: 0)
		return ret
	}
	
    var body: some View {
		List(getResults()) { row in
			HStack(alignment: .center, spacing: 0) {
				if row.id < 0 {
					Text("Test")
						.foregroundColor(.blue)
						.bold()
						.frame(width: listSize.width * 0.80, alignment: .leading)
					Text("Result")
						.foregroundColor(.blue)
						.bold()
				}
				else {
					Text(row.name)
						.frame(width: listSize.width * 0.80, alignment: .leading)
					HStack(alignment: .center, spacing: 8) {
						row.result.image
						Text(row.result.passText)
					}
				}
			}
		}
		.measured { size in
			listSize = size
		}
    }
}

struct ListTest_Previews: PreviewProvider {
	
	static var data: [SPFTestResult] = [
		SPFTestResult(id: 0, name: "Is there a single SPF record?", result: ResultValue.good),
		SPFTestResult(id: 1, name: "Are the tags and values used valid?", result: ResultValue.good),
		SPFTestResult(id: 2, name: "Is there a strong ending to the SPF record (i.e. -all or ~all)", result: ResultValue.good),
		SPFTestResult(id: 3, name: "Are the referenced records free of syntax issues", result: ResultValue.warning),
		SPFTestResult(id: 4, name: "Do all the lookups to other DNS records work?", result: ResultValue.good),
		SPFTestResult(id: 5, name: "Is the number of DNS lookups under the limit of 10?", result: ResultValue.bad)
	]
    static var previews: some View {
		ListTest(results: data)
    }
}
