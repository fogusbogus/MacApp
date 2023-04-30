//
//  EmailSecurity+SummaryItem.swift
//  MCResults
//
//  Created by Matt Hogg on 25/01/2023.
//

import SwiftUI

struct EmailSecurity_SummaryItem<Content: View>: View {
	
	var title: String = "DMARC Insights"
	var status: ResultValue = .good
	
	var content: () -> Content
	
	var body: some View {
		VStack(alignment: .leading, spacing: 32) {
			Rectangle()
				.frame(height: 2)
				.frame(maxWidth: 150)
				.padding(.top, 8)
			HStack(alignment: .top, spacing: 48) {
				VStack(alignment: .leading, spacing: 16){
					Text(title)
						.multilineTextAlignment(.leading)
						.styling(.emailSummaryItemHeading)
						.frame(maxWidth: 150, alignment: .leading)
					status.resizableImage.frame(width: 32, height: 32)
				}
				Group(content: content)
				Spacer()
			}
		}
	}
}

struct EmailSecurity_SummaryItem_Previews: PreviewProvider {
	static var previews: some View {
		EmailSecurity_SummaryItem(title: "DMARC Insights", status: .warning) {
			
			VStack(alignment: .leading, spacing: 16) {
				VStack(alignment:.leading, spacing: 0) {
					Text("Domain-based Message Authentication, Reporting and Conformance (DMARC) ").bold() +
					Text("allows you to set a policy for how receiving email servers should handle email which doesn't pass either SPF or DKIM checks. DMARC also generates reports, which you can use to understand what systems are sending email from your domain, and whether they are passing SPF and DKIM.")
					Text("[Learn more about DMARC](http://www.google.com)")
				}
				
				RecordDescriptor(title: "RECORD") {
					Text(verbatim: "v=DMARC1;p-reject;adkim-s;aspf=s;rua=mailto:dmarc-rua@dmarc.service.gov.uk;")
				}
				BlockQuote {
					Text("DMARC well configured.")
				}
				Text("[More information →͢](http://www.google.com)")
			}
		}
		.styling(.verbatimData)
		.padding()
	}
}
