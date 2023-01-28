//
//  SPF+Results.swift
//  MCResults
//
//  Created by Matt Hogg on 12/01/2023.
//

import SwiftUI

struct SPF_Results: View {
	
	var domain: String = "google.com"
	
	var testResults: [SPFTestResult]
	
	var body: some View {
		
		ResultContainer {
			HStack(alignment: .firstTextBaseline) {
				VStack(alignment: .leading, spacing: 16) {
					Text("Check 2 of 5: Anti-spoofing - SPF")
						.styling(.checkHeading)
					HStack(alignment: .center) {
						ResultValue.good.resizableImage.frame(width:24, height:24)
						Text("We did not detect any issues with your SPF record")
							.styling(.resultHeading)
							.padding(.leading, 8)
					}
					.offset(x:-40, y:0)
					Group { //Heading
						Text("In our evaluation, \(domain) passed is all our tests. Well done. However, note that our tests here are limited in scope: we are only checking for syntax errors in your SPF record. You should also assess if your SPF record is complete as part of your overall approach to anti-spoofing (i.e. alongside DMARC and DKIM).")
							.styling(.description)
					}
					AntiSpoofing_Explained(title: "SPF explained")
					SPF_Results_Tests(domain: domain, results: testResults, tableSize: CGSize.zero)
					Accordian(title: "SPF record for \(domain)") {
						VStack(alignment: .leading) {
							VStack(alignment: .leading, spacing: 0) {
								Text("Record")
									.styling(.verbatimDataHeading)
								HStack(alignment: .center) {
									Text(verbatim: "v=DMARC1; p=quarantine; sp=quarantine; rua=mailto:mailauth-reports@google.com")
										.styling(.verbatimData)
									Spacer()
								}
								.background(Color("Accordian/Item"))
							}
							Text("DMARC record explained")
								.styling(.descriptionHeading)
							
							SPFRecord(result: "v=spf1 include:spf.protection.outlook.com -all")
							
						}
					}
				}.padding([.leading, .trailing], 48)
			}
		}
	}
}


struct SPF_Results_Previews: PreviewProvider {
	static var data: [SPFTestResult] = [
		SPFTestResult(id: 0, name: "Is there a single SPF record?", result: ResultValue.good),
		SPFTestResult(id: 1, name: "Are the tags and values used valid?", result: ResultValue.good),
		SPFTestResult(id: 2, name: "Is there a strong ending to the SPF record (i.e. -all or ~all)", result: ResultValue.good),
		SPFTestResult(id: 3, name: "Are the referenced records free of syntax issues", result: ResultValue.warning),
		SPFTestResult(id: 4, name: "Do all the lookups to other DNS records work?", result: ResultValue.good),
		SPFTestResult(id: 5, name: "Is the number of DNS lookups under the limit of 10?", result: ResultValue.bad)
	]
	
    static var previews: some View {
		ScrollView {
			SPF_Results(testResults: data)
		}
    }
}
