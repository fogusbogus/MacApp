//
//  Messages+Summary.swift
//  MCResults
//
//  Created by Matt Hogg on 17/01/2023.
//

import Foundation

enum Grading {
	case red, amber, green
	
	var result : ResultValue {
		switch self {
			case .red:
				return .bad
			case .amber:
				return .warning
			case .green:
				return .good
		}
	}
}


enum SPF_Summary_Messages {
	case noSpfRecord, multipleSpf, errorInRecord(domain: String, errors: [String]), allGood(domain: String)
	
	var shorthand: String {
		get {
			switch self {
				case .noSpfRecord:
					return "no spf record"
				case .multipleSpf:
					return "multiple spf records"
				case .errorInRecord( _, _):
					return "error in record"
				case .allGood(_):
					return "all good"
			}
		}
	}
	
	var markdown: String {
		get {
			switch self {
				case .noSpfRecord:
					return "We did not detect an SPF record for this domain. SPF should be used alongside DMARC and DKIM to prevent attackers sending malicious emails pretending to come from domain."
				case .multipleSpf:
					return "Domains should have only one SPF record, and we detected that this domain has more than one, which is invalid. We have not conducted an evaluation on any of your SPF records. We recommend reviewing your SPF records and establishing just one record, and then returning to this tool to test."
				case .errorInRecord(let domain, let errors):
					return "In our evaluation, \(domain) failed in \(errors.count) of our tests. This is likely to mean that your SPF record is ineffective as part of your overall approach to anti-spoofing (i.e. alongside DMARC and DKIM). Please refer to your test results for further details and specific advice on addressing issues raised."
				case .allGood(let domain):
					return "In our evaluation, \(domain) passed in all our tests. Well done. However, note that our tests here are limited in scope: we are only checking for syntax errors in your SPF record. You should also assess if your SPF record is complete as part of your overall approach to anti-spoofing (i.e. alongside DMARC and DKIM)."
			}
		}
	}
	
	var title: String {
		get {
			switch self {
				case .noSpfRecord:
					return "This domain is not protected by SPF"
				case .multipleSpf:
					return "We detected that this domain has more than one SPF record"
				case .errorInRecord(_,_):
					return "We detected errors in your SPF record"
				case .allGood(_):
					return "We did not detect any issues with your SPF record"
			}
		}
	}
	
	var grading: Grading {
		get {
			switch self {
				case .allGood(_):
					return .green
				default:
					return .amber
			}
		}
	}
}
