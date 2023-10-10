//
//  CaesarCypherII.swift
//  Kata
//
//  Created by Matt Hogg on 19/01/2023.
//

import Foundation

class CaesarCypherII {
	
	private let alphabet = Array("abcdefghijklmnopqrstuvwxyz")
	
	private func encodeShift(value text: String, shift: Int) -> String {
		guard text.lengthOfBytes(using: .ascii) > 0 else {
			return ""
		}
		
		guard let firstCharacter = Array(text).first(where: { alphabet.contains($0.lowercased().first!) }) else {
			return "aa"
		}

		let newIndex = (alphabet.firstIndex(of: firstCharacter.lowercased().first!)! - shift) % alphabet.count
		return "\(alphabet[newIndex])\(firstCharacter.lowercased())"
	}
	
	private func decodeShift(encodedText: String) -> Int {
		guard encodedText.lengthOfBytes(using: .ascii) > 1 else {
			return 0
		}
		
		guard let first = alphabet.firstIndex(of: encodedText.first!), let second = alphabet.firstIndex(of: Array(encodedText)[1]) else {
			return 0
		}
		
		if second < first {
			return (second + alphabet.count) - first
		}
		return second - first
	}
	
	private func splice(_ s: String) -> [String] {
		let stringLen = s.lengthOfBytes(using: .ascii)
		var maxLen = Int(Float(stringLen) / 5.0 + 0.5)
		if stringLen % 4 == 0 {
			maxLen = Int(Float(stringLen) / 4.0 + 0.5)
		}
		
		//At least 1 character each
		maxLen = maxLen == 0 ? 1 : maxLen
		var ret : [String] = []
		var current = ""
		Array(s).forEach { c in
			if current.lengthOfBytes(using: .ascii) < maxLen {
				current.append(c)
			}
			else {
				ret.append(current)
				current = String(c)
			}
		}
		if current != "" {
			ret.append(current)
		}
		while ret.count < 4 {
			ret.append("")
		}
		if ret.count == 5 {
			while ret[4].lengthOfBytes(using: .ascii) > 3 {
				(0..<4).forEach { i in
					ret[i] += String(ret[4].first!)
					var s = ret[4]
					s.removeFirst()
					ret[4] = s
				}
			}
			if ret[4].isEmpty {
				ret.removeLast()
			}
		}

		return ret
	}
	
	func encode(_ s: String, _ shift: Int) -> [String] {
		guard s.lengthOfBytes(using: .ascii) > 0 else { return [] }
		
		var encoded = ""
		Array(s).forEach { c in
			if let index = alphabet.firstIndex(of: c.lowercased().first!) {
				let newIndex = (index + shift) % alphabet.count
				encoded.append(c.isUppercase ? alphabet[newIndex].uppercased().first! : alphabet[newIndex])
			}
			else {
				encoded.append(c)
			}
		}
		encoded = encodeShift(value: encoded, shift: shift) + encoded
		return splice(encoded)
	}
	func decode(_ arr: [String]) -> String {
		var text = arr.joined()
		let shift = decodeShift(encodedText: text)
		if shift == 0 {
			return text
		}
		
		text = String(text[text.index(text.startIndex, offsetBy: 2)..<text.endIndex])
		var ret = ""
		Array(text).forEach { c in
			if let index = alphabet.firstIndex(of: c.lowercased().first!) {
				let newIndex = (index - shift) % alphabet.count
				ret.append(c.isUppercase ? alphabet[newIndex].uppercased().first! : alphabet[newIndex])
			}
			else {
				ret.append(c)
			}
		}
		return ret
	}
	
}
