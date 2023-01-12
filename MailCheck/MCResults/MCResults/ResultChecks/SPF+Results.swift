//
//  SPF+Results.swift
//  MCResults
//
//  Created by Matt Hogg on 12/01/2023.
//

import SwiftUI

struct SPF_Results: View {
	
	var domain: String = "google.com"
	
	var body: some View {
		
		ResultContainer {
			HStack(alignment: .firstTextBaseline) {
				VStack(alignment: .leading, spacing: 16) {
					Text("Check 2 of 5: Anti-spoofing - SPF")
					HStack(alignment: .center) {
						ResultValue.good.resizableImage.frame(width:24, height:24)
						Text("We did not detect any issues with your SPF record")
							.font(.title3)
							.padding(.leading, 8)
					}
					.offset(x:-40, y:0)
					Group { //Heading
						Text("In our evaluation, \(domain) passed is all our tests. Well done. However, note that our tests here are limited in scope: we are only checking for syntax errors in your SPF record. You should also assess if your SPF record is complete as part of your overall approach to anti-spoofing (i.e. alongside DMARC and DKIM).")
					}
					AntiSpoofing_Explained(title: "SPF explained")
					Accordian(title: "DMARC record for \(domain)") {
						VStack(alignment: .leading) {
							VStack(alignment: .leading, spacing: 0) {
								Text("Record")
									.padding([.top, .bottom], 4)
									.padding([.leading, .trailing])
									.foregroundColor(.white)
									.background(.primary)
									.font(.caption)
								HStack(alignment: .center) {
									Text("v=DMARC1; p=quarantine; sp=quarantine; rua=mailto:mailauth-reports@google.com")
										.font(.caption)
										.padding([.top, .bottom], 4)
									Spacer()
								}
								.background(Color("Accordian/Item"))
							}
							Text("DMARC record explained")
								.font(.title2)
								.bold()
							
							DMARCRecord(result: "v=DMARC1; p=quarantine; sp=quarantine; rua=mailto:mailauth-reports@google.com")
							
						}
					}
				}.padding([.leading, .trailing], 48)
			}
		}
	}
}


struct SPF_Results_Previews: PreviewProvider {
    static var previews: some View {
        SPF_Results()
    }
}
