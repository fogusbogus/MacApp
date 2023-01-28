//
//  SPFRecord.swift
//  MCResults
//
//  Created by Matt Hogg on 23/01/2023.
//

import SwiftUI
import MeasuringView

struct SPFRecord: View {
	
	var result: String = ""
	var domain: String = "my.domain"
	
	@ObservedObject private var measuring = MeasuringView()
	
    var body: some View {
		Accordian(title: "SPF record for \(domain)") {
			VStack(alignment: .leading, spacing: 16) {
				DataHeading(title: "SPF record for \(domain)", data: result)
				Text("SPF record explained and analysed")
					.styling(.resultHeading)
			}
		}
    }
}

struct SPFRecord_Previews: PreviewProvider {
    static var previews: some View {
        SPFRecord(result: "v=spf1 include:spf.protection.outlook.com -all")
			.padding()
    }
}
