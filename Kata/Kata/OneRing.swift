//
//  OneRing.swift
//  Kata
//
//  Created by Matt Hogg on 19/01/2023.
//

import Foundation

/*
 This operation is performed by replacing vowels in the sequence 'a' 'i' 'y' 'e' 'o' 'u' with the vowel three advanced, cyclicly, while preserving case (i.e., lower or upper).
 
 Similarly, consonants are replaced from the sequence 'b' 'k' 'x' 'z' 'n' 'h' 'd' 'c' 'w' 'g' 'p' 'v' 'j' 'q' 't' 's' 'r' 'l' 'm' 'f' by advancing ten letters.
 

 */

class OneRing {
	
	static private let vowels = Array("aiyeou")
	static private let consonants = Array("bkxznhdcwgpvjqtsrlmf")
	
	static func tongues(_ code: String) -> String {
		var ret : [Character] = []
		Array(code).forEach { c in
			let cLower = Character(c.lowercased())
			if var index = vowels.firstIndex(of: cLower) {
				index = (index + 3) % vowels.count
				if c.isUppercase {
					ret.append(Character(vowels[index].uppercased()))
				}
				else {
					ret.append(vowels[index])
				}
			} else {
				if var index = consonants.firstIndex(of: cLower) {
					index = (index + 10) % consonants.count
					if c.isUppercase {
						ret.append(Character(consonants[index].uppercased()))
					}
					else {
						ret.append(consonants[index])
					}
				}
				else {
					ret.append(c)
				}
			}
		}
		return String(ret)
	}

}
