//
//  BlockQuote.swift
//  MCResults
//
//  Created by Matt Hogg on 23/01/2023.
//

import SwiftUI


struct BlockQuoteIssues : View {
	
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
		BlockQuote {
			Text(howManyIssues).bold() +
			Text(" found for ") +
			Text(domain).bold()
		}
	}
}

struct BlockQuote_Previews: PreviewProvider {
    static var previews: some View {
		VStack {
			BlockQuoteIssues(noIssues: 0, domain: "mydomain.com")
			BlockQuoteIssues(noIssues: 1, domain: "mydomain.com")
			BlockQuoteIssues(noIssues: 2, domain: "mydomain.com")
			BlockQuoteIssues(noIssues: 3, domain: "mydomain.com")
		}
		.padding()
    }
}
