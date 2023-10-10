@_private(sourceFile: "Accordian.swift") import Controls
import SwiftUI
import SwiftUI

extension Accordian_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/matt/XCode/MailCheck/Controls/Sources/Controls/Accordian.swift", line: 87)
		Accordian(title: __designTimeString("#11572.[4].[2].property.[0].[0].arg[0].value", fallback: "DKIM Test Results for digital.ncsc.gov.uk"), expanded: __designTimeBoolean("#11572.[4].[2].property.[0].[0].arg[1].value", fallback: true), {
			VStack {
				HStack(alignment: .top, spacing: __designTimeInteger("#11572.[4].[2].property.[0].[0].arg[2].value.[0].arg[0].value.[0].arg[1].value", fallback: 24), content: {
					Text(__designTimeString("#11572.[4].[2].property.[0].[0].arg[2].value.[0].arg[0].value.[0].arg[2].value.[0].arg[0].value", fallback: "You can send up to 20 test emails to add to this list, to cover multiple email sending systems."))
					Button(__designTimeString("#11572.[4].[2].property.[0].[0].arg[2].value.[0].arg[0].value.[0].arg[2].value.[1].arg[0].value", fallback: "Send further test\nemails")) {
						
					}
					.padding()
					.background(.blue)
					.foregroundColor(.white)
					.cornerRadius(__designTimeInteger("#11572.[4].[2].property.[0].[0].arg[2].value.[0].arg[0].value.[0].arg[2].value.[1].modifier[3].arg[0].value", fallback: 4))
				})
				//Group {	//Table
					Table(results) {
						TableColumn(__designTimeString("#11572.[4].[2].property.[0].[0].arg[2].value.[0].arg[0].value.[1].arg[1].value.[0].arg[0].value", fallback: "Timestamp")) { res in
							Text(res.timestamp)
								.lineLimit(__designTimeInteger("#11572.[4].[2].property.[0].[0].arg[2].value.[0].arg[0].value.[1].arg[1].value.[0].arg[1].value.[0].modifier[0].arg[0].value", fallback: 10))
						}
						TableColumn(__designTimeString("#11572.[4].[2].property.[0].[0].arg[2].value.[0].arg[0].value.[1].arg[1].value.[1].arg[0].value", fallback: "System")) { res in
							VStack(alignment: .leading) {
								ForEach(Array(res.system.enumerated()), id:\.element) { i, system in
									Text(system)
										.lineLimit(__designTimeInteger("#11572.[4].[2].property.[0].[0].arg[2].value.[0].arg[0].value.[1].arg[1].value.[1].arg[1].value.[0].arg[1].value.[0].arg[2].value.[0].modifier[0].arg[0].value", fallback: 10))
										.bold(i % __designTimeInteger("#11572.[4].[2].property.[0].[0].arg[2].value.[0].arg[0].value.[1].arg[1].value.[1].arg[1].value.[0].arg[1].value.[0].arg[2].value.[0].modifier[1].arg[0].value.[0]", fallback: 2) == __designTimeInteger("#11572.[4].[2].property.[0].[0].arg[2].value.[0].arg[0].value.[1].arg[1].value.[1].arg[1].value.[0].arg[1].value.[0].arg[2].value.[0].modifier[1].arg[0].value.[1]", fallback: 0))
								}
							}
						}
						TableColumn(__designTimeString("#11572.[4].[2].property.[0].[0].arg[2].value.[0].arg[0].value.[1].arg[1].value.[2].arg[0].value", fallback: "Selectors used")) { res in
							TickMarker(id: __designTimeString("#11572.[4].[2].property.[0].[0].arg[2].value.[0].arg[0].value.[1].arg[1].value.[2].arg[1].value.[0].arg[0].value", fallback: "sel"), mark: res.selectorsUsed, colorDelegate: tickColor)
						}
						TableColumn(__designTimeString("#11572.[4].[2].property.[0].[0].arg[2].value.[0].arg[0].value.[1].arg[1].value.[3].arg[0].value", fallback: "Was DKIM validated?")) { res in
							TickMarker(id: __designTimeString("#11572.[4].[2].property.[0].[0].arg[2].value.[0].arg[0].value.[1].arg[1].value.[3].arg[1].value.[0].arg[0].value", fallback: "val"), mark: res.validated, colorDelegate: tickColor)
						}
						TableColumn(__designTimeString("#11572.[4].[2].property.[0].[0].arg[2].value.[0].arg[0].value.[1].arg[1].value.[4].arg[0].value", fallback: "Was DKIM aligned?")) { res in
							TickMarker(id: __designTimeString("#11572.[4].[2].property.[0].[0].arg[2].value.[0].arg[0].value.[1].arg[1].value.[4].arg[1].value.[0].arg[0].value", fallback: "align"), mark: res.aligned, colorDelegate: tickColor)
								//.frame(midWidth: .infinity)
						}
					}
				//}
			}
			.padding()
			.background(.white)
		})
			.padding([.leading, .trailing], __designTimeInteger("#11572.[4].[2].property.[0].[0].modifier[0].arg[1].value", fallback: 48))
    
#sourceLocation()
    }
}

extension DKIMTickMarkerDelegate {
    @_dynamicReplacement(for: getTickMarkerColor(id:value:)) private func __preview__getTickMarkerColor(id: String?, value: Bool?) -> Color {
        #sourceLocation(file: "/Users/matt/XCode/MailCheck/Controls/Sources/Controls/Accordian.swift", line: 66)
		if let v = value {
			return v ? .green : .red
		}
		return .blue
	
#sourceLocation()
    }
}

extension AccordianPreviewResult {
    @_dynamicReplacement(for: timestamp) private var __preview__timestamp: String {
        get {

#sourceLocation(file: "/Users/matt/XCode/MailCheck/Controls/Sources/Controls/Accordian.swift", line: 56)
			return ts.formatted()
		
#sourceLocation()
}
    }
}

@available(iOS 16.0, *) extension Accordian {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/matt/XCode/MailCheck/Controls/Sources/Controls/Accordian.swift", line: 27)
		VStack {
			HStack(alignment: .center) {
				Text(title).font(.title)
				Spacer()
				Image(systemName: expanded ? __designTimeString("#11572.[1].[5].property.[0].[0].arg[0].value.[0].arg[1].value.[2].arg[0].value.then", fallback: "minus") : __designTimeString("#11572.[1].[5].property.[0].[0].arg[0].value.[0].arg[1].value.[2].arg[0].value.else", fallback: "plus"))
					.onTapGesture {
						expanded = !expanded
					}
			}
			.bold()
			if expanded {
				Group(content: content)
			}
		}
		.padding()
		.background(Color(uiColor: .lightGray))
    
#sourceLocation()
    }
}

import struct Controls.Accordian
import struct Controls.AccordianPreviewResult
import class Controls.DKIMTickMarkerDelegate
import struct Controls.Accordian_Previews
