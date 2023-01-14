//
//  SPF+Results+Tests.swift
//  MCResults
//
//  Created by Matt Hogg on 12/01/2023.
//

import SwiftUI

struct SPFTestResult : Identifiable {
	var id: Int = 0
	var name: String
	var result: ResultValue
}


struct SPF_Results_Tests: View {
	var domain: String = "google.com"
	
	var results: [SPFTestResult] = []
	
	func getResults() -> [SPFTestResult] {
		return results.sorted { $0.id < $1.id }
	}
	
	@State var tableSize: CGSize = CGSize()
	
	var body: some View {
		Accordian(title: "SPF test results for \(domain)") {
			VStack(alignment: .leading) {
				Text("Test results")
					.font(.title3)
					.bold()
				
				ResultsView(results: results, headers: ["Test", "Result"]) { rec, header, measures in
					switch header {
						case "Test":
							return AnyView(
								Text(rec.name)
									.followsWidthOf(measures, key: "WIDTH", alignment: .leading, multiplier: 0.8)
							)
							
						default:
							return AnyView(
								HStack(alignment: .center, spacing: 8) {
									rec.result.image
									Text(rec.result.passText)
								}
							)
					}
				}
				
				
				Group {
					Text("Review your configurations below to understand any errors further. Information on how to configure SPF can be found on the ")
					Button {
						
					} label: {
						Text("NCSC website here.")
					}
				}
				HStack(alignment: .firstTextBaseline) {
					ResultValue.good.resizableImage.frame(width: 48, height: 48)
					Text("Limitations of this checker. ").bold() +
					Text("This checker is checking that your SPF record is syntactically valid. This checker does not check that you have included the right statements or IP addresses. To do this you will need to configure DMARC with an appropriate DMARC tool that allows you to assess if all your email sending systems are adequately covered in your SPF record.")
				}
				Spacer()
			}
		}
	}
}

struct SPF_Results_Tests_Previews: PreviewProvider {
	
	static var data: [SPFTestResult] = [
		SPFTestResult(id: 0, name: "Is there a single SPF record?", result: ResultValue.good),
		SPFTestResult(id: 1, name: "Are the tags and values used valid?", result: ResultValue.good),
		SPFTestResult(id: 2, name: "Is there a strong ending to the SPF record (i.e. -all or ~all)", result: ResultValue.good),
		SPFTestResult(id: 3, name: "Are the referenced records free of syntax issues", result: ResultValue.warning),
		SPFTestResult(id: 4, name: "Do all the lookups to other DNS records work?", result: ResultValue.good),
		SPFTestResult(id: 5, name: "Is the number of DNS lookups under the limit of 10?", result: ResultValue.bad)
	]
	
    static var previews: some View {
		SPF_Results_Tests(results: data)
			.padding()
    }
}
