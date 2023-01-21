//
//  ResultContainer.swift
//  MCResults
//
//  Created by Matt Hogg on 09/01/2023.
//

import SwiftUI

struct ResultContainer<Content: View>: View {
	
	var content: () -> Content

    var body: some View {
		VStack {
			Group {
				Group(content: content)
					.padding()
					.background()
			}
			.padding(1)
			.shadow(radius: 0)	//We don't want the outer shadow to affect us
		}
		.border(Color("ResultBox/Shadow"))
		.cornerRadius(StylingConstants.cornerRadiusLarge)
		.shadow(color: Color("ResultBox/Shadow"), radius: StylingConstants.cornerRadiusSmall, x: StylingConstants.cornerRadiusSmall, y: StylingConstants.cornerRadiusSmall)
		.overlay {
			RoundedRectangle(cornerRadius: StylingConstants.cornerRadiusLarge)
				.stroke(Color("ResultBox/Shadow"))
		}
    }
}

struct ResultContainer_Previews: PreviewProvider {
    static var previews: some View {
		ResultContainer() {
			Accordian(title: "DMARC (anti-spoofing) explained", isExpanded: true) {
				VStack(alignment: .leading, spacing: 16) {
					Text("What is anti-spoofing?")
						.styling(.descriptionHeading)
					Text("Anti-spoofing is about making it difficult for fake emails to be sent from your organisation's email address. DMARC is the key anti-spoofing control that organisations should implement. It is implemented alongside the standards SPF and DKIM.")
						.styling(.description)
					Text("How does it work?")
						.styling(.descriptionHeading)
					Text("Effective anti-spoofing controls on your domains involve implementing the following:")
						.styling(.description)
					Group {
						BulletPoint {
							Text("Sender Policy Framework (SPF)")
								.bold() +
							Text(" allows you to publish IP addresses which should be trusted for your domain.")
						}
						.styling(.description)
						BulletPoint {
							Text("Domain Keys Identified Mail (DKIM)")
								.bold() +
							Text(" allows you to cryptographically sign email you send to show it's from your domain.")
						}
						.styling(.description)
						BulletPoint {
							Text("Domain-based Message Authentication, Reporting and Conformance (DMARC)")
								.bold() +
							Text(" allows you to set a policy for how receiving email servers should handle email which doesn't pass either SPF or DKIM checks. This includes untrusted emails, which should be discarded. DMARC also generates reports, which you can use to understand how your email is being handled.")
						}
					}
					.styling(.description)
					.padding([.leading])
					Text("Where can I find out more?")
						.styling(.descriptionHeading)
					HStack(spacing: 0) {
						Text("Read the ")

						Button("NCSC's Email Security and Anti-Spoofing guidance") {

						}
					}
					.styling(.description)
				}
			}
		}
		.padding()
		//.shadow(radius: 8)
    }
}
