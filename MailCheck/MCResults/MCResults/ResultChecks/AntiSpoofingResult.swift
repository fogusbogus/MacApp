//
//  AntiSpoofingResult.swift
//  MCResults
//
//  Created by Matt Hogg on 10/01/2023.
//

import SwiftUI

struct AntiSpoofingResult: View {
	
	var domain: String = "google.com"
	
	var body: some View {

			ResultContainer {
				HStack(alignment: .firstTextBaseline) {
					VStack(alignment: .leading, spacing: 16) {
						Text("Check 1 of 5: Anti-spoofing - DMARC")
							.styling(.checkHeading)
						HStack(alignment: .center) {
							ResultValue.good.resizableImage.frame(width:24, height:24)
							Text("This domain has a strong DMARC policy in place")
								.styling(.resultHeading)
								.padding(.leading, 8)
						}
						.offset(x:-40, y:0)
						Group { //Heading
							Text(domain).bold() +
							Text(" has a strong DMARC policy in place (a policy of 'p=quarantine' or 'p=reject').")
							Text("This means that fake emails pretending to come from googlemail.com will be junked or blocked altogether.")
						}
						.styling(.description)
						AntiSpoofing_Explained(title: "DMARC (anti-spoofing) explained")

						Accordian(title: "DMARC record for \(domain)") {
							VStack(alignment: .leading) {
								DataHeading(title: "Record", data: "v=DMARC1; p=quarantine; sp=quarantine; rua=mailto:mailauth-reports@google.com")
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

struct AntiSpoofingResult_Previews: PreviewProvider {
	static var previews: some View {
		ScrollView(.vertical, showsIndicators: true, content: {
			AntiSpoofingResult()
			.padding()
			
			
		})
		
	}
}
