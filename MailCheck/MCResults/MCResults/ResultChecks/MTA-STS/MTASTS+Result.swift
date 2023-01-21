//
//  MTASTS+Result.swift
//  MCResults
//
//  Created by Matt Hogg on 20/01/2023.
//

import SwiftUI

struct MTASTS_Result: View {
	
	var domain: String = "zeti.co.uk"
	
	var body: some View {
		ResultContainer {
			HStack(alignment: .firstTextBaseline) {
				VStack(alignment: .leading, spacing: 16) {
					Text("Check 5 of 5: Email privacy - MTA-STS")
						.styling(.checkHeading)
					HStack(alignment: .center) {
						ResultValue.warning.resizableImage.frame(width:24, height:24)
						Text("The privacy of emails sent to this domain is at risk")
							.styling(.resultHeading)
							.padding(.leading, 8)
					}
					.offset(x:-40, y:0)
					
					Text("This domain has MTA-STS set up in 'testing' mode, but have also detected issues with your TLS configuration - this might be an issue with your TLS certificate for example. You should first fix these issues with TLS, and only then proceed with moving to a strong MTA-STS policy of 'enforce'.")
						.styling(.description)
					
					Accordian(title: "MTA-STS explained") {
						VStack(alignment: .leading, spacing: 16) {
							Text("What is MTA-STS")
								.styling(.resultHeading)
							Text("Emails crossing the internet use secure connections encrpyted using Transport Layer Security (TLA). However, there remain vulnerabilities in this method of protecting the confidentiality of emails, whereby a person-in-the-middle can trick incoming connections to send to another server and/or send information in the clear. MTA-STS is a standard designed to address these vulnerabilities.")
							Text("How does it work?")
								.styling(.resultHeading)
							Text("The objectives of MTA-STS are to:")
							Group {
								BulletPoint {
									Text("make it harder for an attacker to get emails sent to an alternative location.")
								}
								BulletPoint {
									Text("make sure that TLS encryption is always used; to prevent attackers downgrading email encryption on emails to clear text.")
								}
							}
							.padding([.leading])
							Text("Where can I find out more?")
								.styling(.resultHeading)
							Text("Read the [NCSC's guidance on configuring MTA-STS](https://www.ncsc.gov.uk/collection/email-security-and-anti-spoofing/using-mta-sts-to-protect-the-privacy-of-your-emails)")
						}
						.styling(.description)
					}
					Accordian(title: "MTA-STS test results for \(domain)") {
						
					}
					
					Accordian(title: "MTA-STS policy for \(domain)") {
						
					}
				}.padding([.leading, .trailing], 48)
			}
		}
	}
}


struct MTASTS_Result_Previews: PreviewProvider {
	static var previews: some View {
		MTASTS_Result()
			.padding()
	}
}
