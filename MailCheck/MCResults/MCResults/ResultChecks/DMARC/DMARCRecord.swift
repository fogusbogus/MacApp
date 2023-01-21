//
//  DMARCRecord.swift
//  MCResults
//
//  Created by Matt Hogg on 11/01/2023.
//

import SwiftUI

struct DMARCResult: Identifiable {
	var id = UUID()
	
	var tag: String
	var value: String
	var valid: Bool?
	var explanation: String
	var error: String
}

extension DMARCResult {
	static func fromResultString(_ result: String) -> [DMARCResult] {
		return DMARCParser.parseDmarcRecord(result).map {DMARCResult(id: UUID(), tag: $0.tag, value: $0.value, valid: $0.valid, explanation: $0.explanation, error: $0.error)}
	}
}

struct DMARCRecord: View {
	var result: String = "v=DMARC1;p=reject;adkim=s;aspf=s;rua=mailto:dmarc-rua@dmarc.service.gov.uk;"
	
	@State var tableSize : CGSize = CGSize()
	
	var body: some View {
		
		ResultsView(results: DMARCResult.fromResultString(result), headers: ["Tag", "Value", "Valid", "Explanation"]) { rec, header, measures in
			switch header {
				case "Tag":
					return AnyView(
						Text(rec.tag)
						//.frame(width:width * 0.15, alignment: .leading)
					)
				case "Value":
					return AnyView(
						Text(rec.value)
							.lineLimit(20)
						//.frame(width: width * 0.3, alignment: .leading)
					)
				case "Valid":
					if let valid = rec.valid {
						if valid {
							return AnyView(
								ResultValue.good.image							)//.frame(width:width * 0.06
																				 //) as! AnyView
							
						}
						else {
							return AnyView(
								ResultValue.bad.image
							)//.frame(width:width * 0.06)
							 //as! AnyView
							
						}
					}
					else {
						return AnyView(
							ResultValue.unknown.image
						)//.frame(width:width * 0.06) as! AnyView
					}
				default:
					return AnyView(Text(rec.explanation.substitute(rec.error))
						.lineLimit(20).frame(alignment: .topLeading))
					
			}

		}

		
	}
}

extension String {
	func substitute(_ others: String...) -> String {
		if !self.isEmptyOrWhitespace() {
			return self
		}
		return others.first { s in
			return !s.isEmptyOrWhitespace()
		} ?? ""
	}
}

struct DMARCRecord_Previews: PreviewProvider {
	static var previews: some View {
		DMARCRecord()
			.padding()
	}
}
