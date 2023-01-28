//
//  DataHeading.swift
//  MCResults
//
//  Created by Matt Hogg on 23/01/2023.
//

import SwiftUI

struct DataHeading: View {
	var title: String = "Record"
	var data: String = "v=DMARC1; p=quarantine; sp=quarantine; rua=mailto:mailauth-reports@google.com"
	
    var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text(title)
				.styling(.dataHeading)
			HStack(alignment: .center) {
				Text(verbatim: data)
					.styling(.summary)
					.padding([.top, .bottom], 8)
				Spacer()
			}
			.padding([.leading, .trailing], 8)
			.background(Color("Accordian/Item"))
		}
    }
}

struct DataHeading_Previews: PreviewProvider {
    static var previews: some View {
        DataHeading()
			.padding()
    }
}
