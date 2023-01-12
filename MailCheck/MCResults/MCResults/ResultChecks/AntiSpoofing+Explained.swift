//
//  AntiSpoofing+Explained.swift
//  MCResults
//
//  Created by Matt Hogg on 12/01/2023.
//

import SwiftUI

struct AntiSpoofing_Explained: View {
	var title: String = "Anti-spoofing explained"
    var body: some View {
		Accordian(title: title, isExpanded: false) {
			VStack(alignment: .leading, spacing: 16) {
				Group {
					Text("What is anti-spoofing?")
						.font(.title3)
						.bold()
					Text("Anti-spoofing is about making it difficult for fake emails to be sent from your organisation's email address. DMARC is the key anti-spoofing control that organisations should pmplement. It is pmplemented alongside the standards SPF and DKIM.")
				}
				Group {
					Text("How does it work?")
						.font(.title3)
						.bold()
					Text("Effective anti-spoofing controls on your domains involve implementing the following:")
					BulletPoint {
						Text("Sender Policy Framework (SPF) ").bold() +
						Text("allows you to publish IP addresses which should be trusted for your domain.")
					}
					BulletPoint {
						Text("Domain Keys Identified Mail (DKIM) ").bold() +
						Text("allows you to cryptographically sign email you send to show it's from your domain.")
					}
					BulletPoint {
						Text("Domain-based Message Authentication, Reporting and Conformance (DMARC) ").bold() +
						Text("allows you to set a policy for how receiving email servers should handle email which doesn't pass either SPF or DKIM checks. This includes untrusted emails, which should be discarded. DMARC also generates reports, which you can use to understand how your email is being handled.")
					}
				}
				Group {
					Text("Where can I find out more?")
						.font(.title3)
						.bold()
					HStack(alignment: .center, spacing: 0) {
						Text("Read the ")
						Button {
							
						} label: {
							Text("NCSC's Email Security and Anti-Spoofing guidance")
						}
						
					}
				}
			}
		}
    }
}

struct AntiSpoofing_Explained_Previews: PreviewProvider {
    static var previews: some View {
        AntiSpoofing_Explained()
    }
}
