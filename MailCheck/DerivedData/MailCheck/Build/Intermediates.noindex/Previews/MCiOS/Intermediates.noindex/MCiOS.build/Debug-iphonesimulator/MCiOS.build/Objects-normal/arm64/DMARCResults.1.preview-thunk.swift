@_private(sourceFile: "DMARCResults.swift") import MCiOS
import UsefulExtensions
import Controls
import SwiftUI
import SwiftUI

extension DMARCResults_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/matt/XCode/MailCheck/MCiOS/MCiOS/DMARCResults.swift", line: 80)
		//Accordian(title: "DMARC Results", expanded: true) {
			GeometryReader { geo in
				DMARCResults(width: geo.size.width)
					.padding()
			}
		//}
    
#sourceLocation()
    }
}

extension DMARCResults {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/matt/XCode/MailCheck/MCiOS/MCiOS/DMARCResults.swift", line: 35)
		HStack {
			VStack(alignment: .leading, spacing: __designTimeInteger("#587.[5].[2].property.[0].[0].arg[0].value.[0].arg[1].value", fallback: 24)) {
				VStack(alignment:.leading, spacing: __designTimeInteger("#587.[5].[2].property.[0].[0].arg[0].value.[0].arg[2].value.[0].arg[1].value", fallback: 0)) {
					Text(__designTimeString("#587.[5].[2].property.[0].[0].arg[0].value.[0].arg[2].value.[0].arg[2].value.[0].arg[0].value", fallback: "Record"))
						.bold()
						.padding([.leading, .trailing])
						.background(Color(__designTimeString("#587.[5].[2].property.[0].[0].arg[0].value.[0].arg[2].value.[0].arg[2].value.[0].modifier[2].arg[0].value.arg[0].value", fallback: "banner/beta/background")))
						.foregroundColor(Color(__designTimeString("#587.[5].[2].property.[0].[0].arg[0].value.[0].arg[2].value.[0].arg[2].value.[0].modifier[3].arg[0].value.arg[0].value", fallback: "banner/beta/foreground")))
					HStack {
						Text(result)
						Spacer()
					}
					.padding()
					.background(Color(__designTimeString("#587.[5].[2].property.[0].[0].arg[0].value.[0].arg[2].value.[0].arg[2].value.[1].modifier[1].arg[0].value.arg[0].value", fallback: "colors/gray")))
				}
				Text(__designTimeString("#587.[5].[2].property.[0].[0].arg[0].value.[0].arg[2].value.[1].arg[0].value", fallback: "DMARC record explained"))
					.font(.title2)
					.bold()
				Table(DMARCResult.fromResultString(result)) {
					TableColumn(__designTimeString("#587.[5].[2].property.[0].[0].arg[0].value.[0].arg[2].value.[2].arg[1].value.[0].arg[0].value", fallback: "Tag")) { rec in
						Text(rec.tag)
					}
					.width(width * __designTimeFloat("#587.[5].[2].property.[0].[0].arg[0].value.[0].arg[2].value.[2].arg[1].value.[0].modifier[0].arg[0].value.[0]", fallback: 0.10))
					TableColumn(__designTimeString("#587.[5].[2].property.[0].[0].arg[0].value.[0].arg[2].value.[2].arg[1].value.[1].arg[0].value", fallback: "Value")) { rec in
						Text(rec.value)
							.lineLimit(__designTimeInteger("#587.[5].[2].property.[0].[0].arg[0].value.[0].arg[2].value.[2].arg[1].value.[1].arg[1].value.[0].modifier[0].arg[0].value", fallback: 20))
					}
					.width(width * __designTimeFloat("#587.[5].[2].property.[0].[0].arg[0].value.[0].arg[2].value.[2].arg[1].value.[1].modifier[0].arg[0].value.[0]", fallback: 0.3))
					TableColumn(__designTimeString("#587.[5].[2].property.[0].[0].arg[0].value.[0].arg[2].value.[2].arg[1].value.[2].arg[0].value", fallback: "Valid")) { rec in
						TickMarker(id: __designTimeString("#587.[5].[2].property.[0].[0].arg[0].value.[0].arg[2].value.[2].arg[1].value.[2].arg[1].value.[0].arg[0].value", fallback: "dmarc"), mark: rec.valid, colorDelegate: nil, noSpacer: __designTimeBoolean("#587.[5].[2].property.[0].[0].arg[0].value.[0].arg[2].value.[2].arg[1].value.[2].arg[1].value.[0].arg[3].value", fallback: true))
					}
					.width(width * __designTimeFloat("#587.[5].[2].property.[0].[0].arg[0].value.[0].arg[2].value.[2].arg[1].value.[2].modifier[0].arg[0].value.[0]", fallback: 0.10))
					TableColumn(__designTimeString("#587.[5].[2].property.[0].[0].arg[0].value.[0].arg[2].value.[2].arg[1].value.[3].arg[0].value", fallback: "Explanation")) { rec in
						Text(rec.explanation.substitute(rec.error))
							.lineLimit(__designTimeInteger("#587.[5].[2].property.[0].[0].arg[0].value.[0].arg[2].value.[2].arg[1].value.[3].arg[1].value.[0].modifier[0].arg[0].value", fallback: 20))
					}
					
				}
			}
		}
    
#sourceLocation()
    }
}

extension DMARCResult {
    @_dynamicReplacement(for: fromResultString(_:)) private static func __preview__fromResultString(_ result: String) -> [DMARCResult] {
        #sourceLocation(file: "/Users/matt/XCode/MailCheck/MCiOS/MCiOS/DMARCResults.swift", line: 24)
		return DMARCParser.parseDmarcRecord(result).map {DMARCResult(id: UUID(), tag: $0.tag, value: $0.value, valid: $0.valid, explanation: $0.explanation, error: $0.error)}
	
#sourceLocation()
    }
}

import struct MCiOS.DMARCResult
import struct MCiOS.DMARCResults
import struct MCiOS.DMARCResults_Previews
