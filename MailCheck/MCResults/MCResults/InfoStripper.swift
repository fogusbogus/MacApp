//
//  InfoStripper.swift
//  MCiOS
//
//  Created by Matt Hogg on 06/12/2022.
//

import Foundation
import UsefulExtensions

extension String {
	func afterLast(_ afterThis: String, _ allIfMissing: Bool = false) -> String {
		let bits = self.splitToArray(afterThis)
		if bits.count == 0 {
			return ""
		}
		if bits.count == 1 {
			return allIfMissing ? self : ""
		}
		return bits.last!
	}
}

class InfoStripper {
	static func firstIndexOf(text: String, arguments: String...) -> (index: Int, item: String) {
		
		var earliestIndex = Int.max
		var earliestItem = ""
		
		arguments.forEach { arg in
			if let index = text.indexOfAny(arg) {
				if index < earliestIndex && index >= 0 {
					earliestIndex = index
					earliestItem = arg
				}
			}
		}
		if earliestItem == "" {
			return (index: -1, item: "")
		}
		return (index: earliestIndex, item: earliestItem)
	}
	
	static func getValues(text: String) -> [(key: String, value: String)] {
		var currentKey = ""
		if text.isEmptyOrWhitespace() {
			return []
		}
		
		var text = text.replacingOccurrences(of: "\n", with: " ").replacingOccurrences(of: "\r", with: " ").replacingOccurrences(of: "\t", with: " ")
		var ret : [(key: String, value: String)] = []
		while text.length() > 0 {
			let first = firstIndexOf(text: text, arguments: ";", "=")
			if first.index < 0 {
				//No more delimiters, so puch whatever's left with the current key
				ret.append((key: currentKey, value: text))
				text = ""
			}
			else {
				if first.item == "=" {
					let pushValue = text.before("=").trim()
					let pushKey = currentKey
					
					//Get the next key
					currentKey = text.before("=").afterLast(" ", true).trim()
					ret.append((key: pushKey, value: pushValue.substring(from: 0, length: pushValue.length() - currentKey.length()).trim()))
					
					text = text.after("=")
				}
				else {
					ret.append((key: currentKey, value: text.before(";", returnAllWhenMissing: true).trim()))
					text = text.after(";")
				}
			}
		}
		return ret.filter { !$0.value.isEmptyOrWhitespace() && !$0.key.isEmptyOrWhitespace() }
	}
}

struct DMARCResultItem {
	var tag: String
	var valid: Bool?
	var value: String
	var explanation: String
	var error: String
}

class DMARCParser {
	private static func parseV(_ value: String) -> DMARCResultItem {
		let correctValue = (value == "DMARC1")
		return DMARCResultItem(tag: "v", valid: correctValue, value: value, explanation: correctValue ? "Indicates a DMARC policy." : "", error: correctValue ? "" : "Unsupported value for tag 'v': \(value)")
	}
	
	private static func parseASPF(_ value: String) -> DMARCResultItem {
		let validValue = value.isOneOf("r", "s")
		let explanations : [String:String] = ["r":"Relaxed SPF identifier alignment is required. For example, if outbound email uses the domain 'example.com' in the header from address, but the separate envelope from address uses 'mail.example.com', then an SPF alignment check will still pass.", "s":"Strict SPF identifier alignment is required. For example, if outbound email uses the domain 'example.com' in the header from address, but the separate envelope from address uses 'mail.example.com', then an SPF alignment check will fail."]
		
		let explanation = explanations[value] ?? ""
		return DMARCResultItem(tag: "aspf", valid: validValue, value: value, explanation: explanation, error: validValue ? "" : "Unsupported value for tag 'aspf': \(value)")
	}
	
	private static func parseADKIM(_ value: String) -> DMARCResultItem {
		let validValue = value.isOneOf("r", "s")
		let explanations : [String:String] = ["r":"Relaxed DKIM identifier alignment is required. For example, if outbound email uses the domain ‘example.com’ in the header from address, but the email is DKIM signed using the domain 'mail.example.com', then a DKIM alignment check will still pass.", "s":"Strict DKIM identifier alignment is required. For example, if outbound email uses the domain ‘example.com’ in the header from address, but the email is DKIM signed using the domain 'mail.example.com', then a DKIM alignment check will fail."]
		
		let explanation = explanations[value] ?? ""
		return DMARCResultItem(tag: "adkim", valid: validValue, value: value, explanation: explanation, error: validValue ? "" : "Unsupported value for tag 'adkim': \(value)")
	}
	
	private static func parseP(_ value: String) -> DMARCResultItem {
		let validValue = value.isOneOf("reject", "none", "quarantine")
		let explanations : [String:String] = ["reject":"Policy is reject. This indicates to receivers that email which doesn't pass DMARC checks should be discarded.", "none":"Policy is none. This indicates to receivers not to apply DMARC based filtering, but to provide reporting as configured with other tags.", "quarantine":"Policy is quarantine. This indicates to receivers that email which doesn't pass DMARC checks should be placed in the spam folder."]
		
		let explanation = explanations[value] ?? ""
		return DMARCResultItem(tag: "p", valid: validValue, value: value, explanation: explanation, error: validValue ? "" : "Unsupported value for tag 'p': \(value)")
	}
	
	private static func parseSP(_ value: String) -> DMARCResultItem {
		let validValue = value.isOneOf("reject", "none", "quarantine")
		let explanations : [String:String] = ["reject":"Subdomain Policy is reject. This indicates to receivers that email which doesn't pass DMARC checks should be discarded.", "none":"Subdomain Policy is none. If an email from a subdomain fails DMARC checks, this policy instructs receivers to still send on the email.", "quarantine":"Subdomain Policy is quarantine. This indicates to receivers that email which doesn't pass DMARC checks should be placed in the spam folder."]
		
		let explanation = explanations[value] ?? ""
		return DMARCResultItem(tag: "sp", valid: validValue, value: value, explanation: explanation, error: validValue ? "" : "Unsupported value for tag 'sp': \(value)")
	}
	
	private static func parseFO(_ value: String) -> DMARCResultItem {
		
		let validValue = value.isOneOf("d", "s", "0", "1")
		
		return DMARCResultItem(tag: "fo", valid: validValue, value: value, explanation: validValue ? "Specifies when to send failure reports." : "", error: validValue ? "" : "Unsupported value for tag 'fo': \(value)")
	}
	
	private static func parseRF(_ value: String) -> DMARCResultItem {
		let validValue = value.isOneOf("afrf")
		
		return DMARCResultItem(tag: "rf", valid: validValue, value: value, explanation: validValue ? "Failure report format. The default is \"Authentication Failure Reporting Format\" (afrf), and this is the only value currently supported." : "", error: validValue ? "" : "Unsupported value for tag 'rf': \(value)")
	}
	
	private static func parsePCT(_ value: String) -> DMARCResultItem {
		var parsed = false
		if let _ = Int(value) {
			parsed = true
		}
		let validValue = (0...100).contains(Int(value) ?? -1)
		let error = validValue ? "" : (parsed ? "Unsupported value for tag 'pct': \(value) (outside the range 0-100)" : "Unsupported value for tag 'pct': \(value) (not a number)")
		let explanation = validValue ? "Policy should be applied by receivers to \(value)% of mail." : ""
		
		return DMARCResultItem(tag: "pct", valid: validValue, value: value, explanation: explanation, error: error)
	}
	
	private static func parseRI(_ value: String) -> DMARCResultItem {
		var parsed = false
		if let _ = Int(value) {
			parsed = true
		}
		let validValue = (Int(value) ?? -1) >= 0
		let error = validValue ? "" : (parsed ? "Unsupported value for tag 'ri': \(value) (not greater or equal to zero)" : "Unsupported value for tag 'ri': \(value) (not a number)")
		let explanation = validValue ? "Requested aggregate reporting interval is \(value) second(s)." : ""
		
		return DMARCResultItem(tag: "ri", valid: validValue, value: value, explanation: explanation, error: error)
	}
	
	
	private static func parseRUF(_ value: String) -> DMARCResultItem {
		let uris = value.splitToArray(",").map {$0.trim()}
		var valid = true
		var errors : [String] = []
		uris.forEach { uri in
			if !isValidUri(uri) {
				valid = false
				errors.append("Invalid uri: Should be of the format mailto:user@example.com. Was: \(uri)")
			}
		}
		
		return DMARCResultItem(tag: "ruf", valid: valid, value: value, explanation: valid ? "Failure reports should be sent to to the specified addresses. Sometimes referred to as forensic reports, these provide detailed feedback from receivers on emails that have failed DMARC checks." : "", error: errors.joined(separator: ", "))
	}
	
	private static func parseRUA(_ value: String) -> DMARCResultItem {
		let uris = value.splitToArray(",").map {$0.trim()}
		var valid = true
		var errors : [String] = []
		uris.forEach { uri in
			if !isValidUri(uri) {
				valid = false
				errors.append("Invalid uri: Should be of the format mailto:user@example.com. Was: \(uri)")
			}
		}
		
		return DMARCResultItem(tag: "rua", valid: valid, value: value, explanation: valid ? "Aggregate reports should be sent to to the specified addresses. These reports provide summarised feedback from receivers on whether emails from the domain passed anti-spoofing checks (DMARC, SPF, DKIM)." : "", error: errors.joined(separator: ", "))
	}
	
	private static func isValidUri(_ url: String) -> Bool {
		let parts = url.splitToArray(":")
		if parts.count == 2 && parts.first == "mailto" {
			return isValidEmail(parts.last!)
		}
		return false
	}
	
	private static func isValidEmail(_ email: String) -> Bool {
		/*
		 function containsDuplicateTagNames(tagSummary) {
		 return tagSummary.filter(x => x.count > 1).length > 0;
		 }
		 */
		do {
			let regex = try Regex("/^(([^<>()[\\]\\\\.,;:\\s@\"]+(\\.[^<>()[\\]\\\\.,;:\\s@\"]+)*)|(\".+\"))@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$/")
			return try regex.wholeMatch(in: email) != nil
		}
		catch {
			return false
		}
	}
	
	static func parseDmarcRecord(_ record: String) -> [DMARCResultItem] {
		var ret : [DMARCResultItem] = []
		let tags = InfoStripper.getValues(text: record)
		tags.forEach { kv in
			switch kv.key {
				case "v":
					ret.append(parseV(kv.value))
				case "p":
					ret.append(parseP(kv.value))
				case "sp":
					ret.append(parseSP(kv.value))
				case "pct":
					ret.append(parsePCT(kv.value))
				case "ri":
					ret.append(parseRI(kv.value))
				case "aspf":
					ret.append(parseASPF(kv.value))
				case "adkim":
					ret.append(parseADKIM(kv.value))
				case "fo":
					ret.append(parseFO(kv.value))
				case "rf":
					ret.append(parseRF(kv.value))
				case "rua":
					ret.append(parseRUA(kv.value))
				case "ruf":
					ret.append(parseRUF(kv.value))
				default:
					ret.append(DMARCResultItem(tag: kv.key, valid: false, value: kv.value, explanation: "", error: "Unknown tag \(kv.key) with value \(kv.value)"))
			}
		}
		return ret
	}
}
