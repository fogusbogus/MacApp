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
		Table(DMARCResult.fromResultString(result)) {
			TableColumn("Tag") { rec in
				Text(rec.tag)
			}
			.width(tableSize.width * 0.15)
			TableColumn("Value") { rec in
				Text(rec.value)
					.lineLimit(20)
			}
			.width(tableSize.width * 0.3)
			TableColumn("Valid") { rec in
				if let valid = rec.valid {
					if valid {
						ResultValue.good.image
					}
					else {
						ResultValue.bad.image
					}
				}
				else {
					ResultValue.unknown.image
				}
			}
			.width(tableSize.width * 0.06)
			//.width(width * 0.10)
			TableColumn("Explanation") { rec in
				Text(rec.explanation.substitute(rec.error))
					.lineLimit(20)
			}
			
		}
		.measured { newSize in
			tableSize = newSize
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
		GeometryReader { geo in
			DMARCRecord(tableSize: geo.size)
				.padding()
		}
    }
}
