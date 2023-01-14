//
//  Accordian.swift
//  MCResults
//
//  Created by Matt Hogg on 09/01/2023.
//

import SwiftUI

struct BulletPoint<Content: View> : View {
	init(@ViewBuilder _ content: @escaping () -> Content) {
		self.content = content
	}
	
	var content: () -> Content
	
	var body: some View {
		HStack(alignment: .top, spacing: 16) {
			Text("•")
			Group(content: content)
		}
	}
}

struct Accordian<Content: View>: View {
	
	init(title: String, isExpanded: Bool = false, @ViewBuilder _ content: @escaping () -> Content) {
		self.title = title
		self.content = content
	}
	
	var title: String = "Description"
	@State var isExpanded: Bool = true
	var content: () -> Content
	
    var body: some View {
		VStack(alignment: .leading) {
			HStack(alignment: .center) {
				Text(title)
					.font(.title3)
					.bold()
				Spacer()
				Button {
					isExpanded = !isExpanded
				} label: {
					Image(systemName: isExpanded ? "minus" : "plus")
						.bold()
				}
				.foregroundColor(.primary)
			}
			if isExpanded {
				HStack {
					Group(content: content)
					Spacer()
				}
				.padding()
				.background(.background)
				.padding([.top])
			}
		}
		.padding(8)
		.background(Color("Accordian/Item"))
    }
}

struct Accordian_Previews: PreviewProvider {
	static var previews: some View {
		Accordian(title: "DMARC (anti-spoofing) explained", isExpanded: true) {
			VStack(alignment: .leading, spacing: 16) {
				Text("What is anti-spoofing?")
					.font(.title2)
				Text("Anti-spoofing is about making it difficult for fake emails to be sent from your organisation's email address. DMARC is the key anti-spoofing control that organisations should implement. It is implemented alongside the standards SPF and DKIM.")
				Text("How does it work?")
				.font(.title2)
				Text("Effective anti-spoofing controls on your domains involve implementing the following:")
				Group {
					BulletPoint {
						Text("Sender Policy Framework (SPF)")
							.bold() +
						Text(" allows you to publish IP addresses which should be trusted for your domain.")
					}
					BulletPoint {
						Text("Domain Keys Identified Mail (DKIM)")
							.bold() +
						Text(" allows you to cryptographically sign email you send to show it's from your domain.")
					}
					BulletPoint {
						Text("Domain-based Message Authentication, Reporting and Conformance (DMARC)")
							.bold() +
						Text(" allows you to set a policy for how receiving email servers should handle email which doesn't pass either SPF or DKIM checks. This includes untrusted emails, which should be discarded. DMARC also generates reports, which you can use to understand how your email is being handled.")
					}
				}
				.padding([.leading])
				Text("Where can I find out more?")
					.font(.title2)
				HStack(spacing: 0) {
					Text("Read the ")

					Button("NCSC's Email Security and Anti-Spoofing guidance") {
						
					}
				}
			}
		}
		.padding()
		.border(.black)
	}
}

