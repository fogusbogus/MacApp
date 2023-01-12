//
//  SummaryResult.swift
//  MCResults
//
//  Created by Matt Hogg on 10/01/2023.
//

import SwiftUI

enum ResultValue : Codable {
	case good, bad, warning, unknown
	
	var image: some View {
		switch self {
			case .good:
				return AnyView(Image(systemName: "checkmark.circle.fill")
					.foregroundColor(Color("Status/Good")))
			case .bad:
				return AnyView(Image(systemName: "multiply.circle.fill")
					.foregroundColor(Color("Status/Bad")))
			case .warning:
				return AnyView(Image(systemName: "exclamationmark.circle.fill")
					.foregroundColor(Color("Status/Warning")))
			case .unknown:
				return AnyView(Image(systemName: "exclamationmark.circle.fill")
					.foregroundColor(Color("Status/Unknown"))
					.rotationEffect(Angle(degrees: 180)))
		}
	}
	
	var resizableImage: some View {
		switch self {
			case .good:
				return AnyView(Image(systemName: "checkmark.circle.fill").resizable()
					.foregroundColor(Color("Status/Good")))
			case .bad:
				return AnyView(Image(systemName: "multiply.circle.fill").resizable()
					.foregroundColor(Color("Status/Bad")))
			case .warning:
				return AnyView(Image(systemName: "exclamationmark.triangle.fill").resizable().foregroundColor(Color("Status/Warning")))
			case .unknown:
				return AnyView(Image(systemName: "exclamationmark.circle.fill").resizable().foregroundColor(Color("Status/Unknown"))
					.rotationEffect(Angle(degrees: 180)))
		}
	}
	
	var badCount: Int {
		return self == .good ? 0 : 1
	}
	
	var passText: String {
		switch self {
			case .good:
				return "Pass"
			case .bad:
				return "Fail"
			case .warning:
				return "Pass"
			case .unknown:
				return "Fail"
		}
	}
}

struct SummaryResultType: Identifiable {
	var id : Int
	var name: String
	var items: [SummaryTypeResultValue]
}

struct SummaryTypeResultValue: Identifiable {
	var id : Int
	var name: String
	var result: ResultValue
}

struct SummaryResult: View {
	
	var data: SummaryItems
	
	var noIssues : Int {
		return data.antiSpoof.dkim.badCount + data.antiSpoof.dmarc.badCount + data.antiSpoof.spf.badCount + data.emailPrivacy.tls.badCount + data.emailPrivacy.mtaSts.badCount
	}
	
    var body: some View {
		ResultContainer {
			VStack(alignment: .leading) {
				Text("Your result")
					.font(.title2)
					.bold()
				IssuesLegend(noIssues: noIssues, domain: "googlemail.com")
					.font(.body)
				HStack(alignment: .center) {
					Spacer()
					Group {
						Text("Anti-spoofing").bold()
						Text("DMARC:")
						data.antiSpoof.dmarc.image
						Text("SPF:")
						data.antiSpoof.spf.image
						Text("DKIM:")
						data.antiSpoof.dkim.image
					}
					Spacer()
					Group {
						Text("Email privacy").bold()
						Text("TLS:")
						data.emailPrivacy.tls.image
						Text("MTA-STS:")
						data.emailPrivacy.mtaSts.image
					}
					Spacer()
				}
				HStack(alignment:.center) {
					Spacer()
					Text("DKIM tests can only be completed using our extended tests")
					Button {
						
					} label: {
						Text("Proceed")
					}
					.standardBlue()
					Spacer()
				}
			}
			.font(.caption2)
			.padding([.leading, .trailing], 64)
			.frame(minWidth: 400)
		}
    }
}

struct SummaryResult_Previews: PreviewProvider {

	static func getData() -> SummaryItems {
		return SummaryItems(antiSpoof: SummaryItemsAntiSpoofing(dmarc: .good, spf: .warning, dkim: .unknown), emailPrivacy: SummaryItemsEmailPrivacy(tls: .good, mtaSts: .bad))
		
	}
	
    static var previews: some View {
			SummaryResult(data: getData())
			.padding()
    }
}

struct SummaryItems : Codable {
	var antiSpoof : SummaryItemsAntiSpoofing
	var emailPrivacy : SummaryItemsEmailPrivacy
}

struct SummaryItemsAntiSpoofing : Codable {
	var dmarc: ResultValue
	var spf: ResultValue
	var dkim: ResultValue
}

struct SummaryItemsEmailPrivacy : Codable {
	var tls: ResultValue
	var mtaSts: ResultValue
}

struct IssuesLegend : View {
	
	var noIssues: Int
	var domain: String
	
	private var howManyIssues: String {
		get {
			if noIssues == 0 {
				return "No issues"
			}
			if noIssues == 1 {
				return "1 issue"
			}
			return "\(noIssues) issues"
		}
	}
	
	var body: some View {
		HStack(alignment: .center) {
			Group {
				Text(howManyIssues).bold() +
				Text(" found for ") +
				Text(domain).bold()
			}
				.padding()
				.padding(.leading, 4)
				.foregroundColor(Color("Issues/Fore"))
				.overlay {
					HStack {
						Rectangle()
							.foregroundColor(Color("Issues/Bar"))
							.frame(width: 8)
						Spacer()
					}
				}
			Spacer()
		}
		.background(Color("Issues/Back"))
	}
}
