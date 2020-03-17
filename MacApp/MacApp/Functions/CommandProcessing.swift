//
//  CommandProcessing.swift
//  MacApp
//
//  Created by Matt Hogg on 26/11/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import SQLDB
import UsefulExtensions
import RegisterDB

class CommandProcessing {
	static func Criteria(code: String, criteria: String) -> Bool {
		var polar = false, value = false
		var criteria = criteria
		
		while criteria.length() > 0 {
			if criteria.starts(with: "(") {
				var sub = criteria.substring(from: 1)
				
				var pCount = 1
				var innards = ""
				while pCount > 0 {
					let idx = sub.indexOfAny("(", ")")
					
					if idx == nil {
						pCount = 0
					}
					else {
						if sub.substring(from: idx!).starts(with: "(") {
							pCount += 1
						}
						else {
							pCount -= 1
						}
						innards += sub.substring(from: 0, length: idx!)
						sub = sub.substring(from: idx! + 1)
					}
				}
				criteria = sub
				//innards = innards.substring(from: 0, length: innards.length())
				value = Criteria(code: code, criteria: innards)
				if polar {
					value = !value
				}
				polar = false
			}
			else {
				if criteria.starts(with: "!") {
					polar = !polar
					criteria = criteria.substring(from: 1)
				}
				else {
					let or = criteria.indexOfAny("|") ?? criteria.length()
					let and = criteria.indexOfAny(",") ?? criteria.length()
					
					if or == and {
						if criteria.implies("COMPLETE") {
							value = true //"COMPLETE"	//Globals.IsComplete(code)
						}
						else {
							if criteria.starts(with: "#") {
								value = Criteria(code: code, criteria: GetGroupCodesForCriteria(groupCode: criteria.substring(from: 1)))
							}
							else {
								value = ("~" + code.trim().uppercased() + "~").contains("~" + criteria.trim().uppercased() + "~")
							}
						}
						if polar {
							value = !value
						}
						return value
					}
					
					if or < and {
						value = Criteria(code: code, criteria: criteria.substring(from: 0, length: or))
						if polar {
							value = !value
						}
						if value {
							return true
						}
						return Criteria(code: code, criteria: criteria.substring(from: or + 1))
					}
					if and < or {
						value = Criteria(code: code, criteria: criteria.substring(from: 0, length: and))
						if polar {
							value = !value
						}
						if !value {
							return false
						}
						return Criteria(code: code, criteria: criteria.substring(from: and + 1))

					}
				}
			}
		}
		return value
	}
	
	static func GetGroupCodesForCriteria(groupCode: String) -> String {
		let db = SQLDBInstance()
		db.open(path: "RegisterDB.sqlite", openCurrent: true)
		let ag = ActionGroup(db: db, groupCode.lowercased().trim())
		let codes = ag.Codes.split(separator: "~")
		
		return "(" + "|".join(codes) + ")"
	}
}
