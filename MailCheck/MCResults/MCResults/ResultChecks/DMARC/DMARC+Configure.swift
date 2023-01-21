//
//  DMARC+Configure.swift
//  MCResults
//
//  Created by Matt Hogg on 19/01/2023.
//

import SwiftUI

struct DMARC_Configure: View {
    var body: some View {
		Accordian(title: "How to configure a DMARC policy") {
			VStack(alignment: .leading, spacing: 16) {
				Text("Although a DMARC policy is quick to set up, this should be done carefully and over time to ensure that all legitimate emails continue to be delivered.")
				Text("It is the responsibility of the domain owner to set up a DMARC policy. You may need to speak to your email provider to find out how to do this.")
				Text("Read our guidance on [Email Security and Anti-Spoofing](http://www.google.com) which covers everything you need to know including:")
				Group { //Numbered
					NumberedPoint(1) {
						VStack(alignment: .leading) {
							Text("Signing up to a DMARC tool")
								.styling(.numberedHeading)
							Text("A range of tools are available to help you set up and manage your DMARC policy. You can sign up for the full [NCSC Mail Check service](http://www.google.com) if your organisation is in the UK public sector, or a charity, university, college or school. If not, [commercial alternatives](http://www.google.com) are available.")
						}
						.styling(.numberedDescription)
					}
					
					NumberedPoint(2) {
						VStack(alignment: .leading) {
							Text("How to establish a basic DMARC policy")
								.styling(.numberedHeading)
							Text("This should be a simple and safe policy that won't affect delivery of your email but will allow you to see exactly what's happening with your email delivery.")
								.styling(.numberedDescription)
						}
					}
					
					NumberedPoint(3) {
						VStack(alignment: .leading) {
							Text("Configuring each of your mail sending systems so that they are trusted")
								.styling(.numberedHeading)
							Text("How to identify and configure each of your email sending systems with standards like SPF and DKIM which allow recipients to know they are trusted senders.")
								.styling(.numberedDescription)
						}
					}
					NumberedPoint(4) {
						VStack(alignment: .leading) {
							Text("Moving to a strong DMARC policy")
								.styling(.numberedHeading)
							Text("How and when to change your policy to a strong policy that will quarantine or reject untrusted emails.")
								.styling(.numberedDescription)
						}
					}
					Text("")
					Button {
						
					} label: {
						Text("Read the full NCSC guidance")
							.styling(.numberedDescription)
					}
					.standardBlue()

				}
			}
		}
    }
}



struct DMARC_Configure_Previews: PreviewProvider {
    static var previews: some View {
        DMARC_Configure()
			.padding()
    }
}
