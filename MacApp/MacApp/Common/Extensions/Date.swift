//
//  Date.swift
//  Common
//
//  Created by Matt Hogg on 06/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

public extension Date {
	func toISOString() -> String {
		return ISO8601DateFormatter().string(from: self)
	}
	
	@discardableResult
	static func fromISOString(date: String) -> Date {
		return ISO8601DateFormatter().date(from: date) ?? Date()
	}
	
	func disregardTime() -> Date {
		return self.toString("yyyy-MM-dd").toDate("yyyy-MM-dd")!
	}
	
	func year() -> Int {
		return Int(toString("yyyy"))!
	}
	
	func month() -> Int {
		return Int(toString("MM"))!
	}
	
	func day() -> Int {
		return Int(toString("dd"))!
	}
	
	func hours() -> Int {
		return Int(toString("HH"))!
	}
	
	func minutes() -> Int {
		return Int(toString("mm"))!
	}
	func seconds() -> Int {
		return Int(toString("ss"))!
	}
	
	func dayDifference(_ other: Date) -> Int {
		var first = self.absoluteDate()
		var second = other.absoluteDate()
		if first > second {
			let tmp = first
			first = second
			second = tmp
		}
		let dc = second.timeIntervalSince(first) / 86400.0
		return Int(dc)
		
	}

	
	func friendlyDate() -> String {
		let today = Date().disregardTime()
		let dtDay = self.disregardTime()
		
		var when = ""
		let hour = Int(self.toString("HHmm"))!
		if hour == 0 {
			when = "midnight"
		}
		else if hour == 1200 {
			when = "midday"
		}
		else if hour < 1200 {
			when = "morning"
		}
		else if hour < 1800 {
			when = "afternoon"
		}
		else {
			when = "evening"
		}
		
		var formalTime = self.toString("h:mmaa").lowercased()
		if hour == 0 || hour == 1200 {
			formalTime = when
			when = ""
		}
		else {
			when = " " + when
		}
		
		let dd = self.dayDifference(dtDay)
		if dd == 0 {
			return "today at \(formalTime)"
		}
		if dd == 1 {
			return "yesterday\(when) at \(formalTime)"
		}
		if dd == -1 {
			return "tomorrow\(when) at \(formalTime)"
		}
		if (1...6).contains(dd) {
			return "last \(self.toString("EEEE"))\(when) at \(formalTime)"
		}
		if dd < 0 && dd > -7 {
			return "next \(self.toString("EEEE"))\(when) at \(formalTime)"
		}
		return "\(dd) days ago at \(formalTime)"
	}
	
	func friendlyDateFull() -> String {
		let today = Date().disregardTime()
		let dtDay = self.disregardTime()
		
		var fullDate = dtDay.toString("EEEE d")
		let day = dtDay.day()
		fullDate += day.match(defaultValue: "th", pairs: [1:"st", 2:"nd", 3:"rd", 21:"st", 22:"nd", 23:"rd", 31:"st"])
		fullDate += " " + dtDay.toString("MMMM yyyy")
		return fullDate
	}
	
	func friendlyDateDescriptive() -> String {
		let dd = self.dayDifference(Date())
		
		if dd == 0 {
			return "Today"
		}
		if dd == 1 {
			return "Yesterday"
		}
		if dd == -1 {
			return "Tomorrow"
		}
		if (2...6).contains(dd) {
			return "\(dd) days ago"
		}
		if dd > 7 {
			let wks = dd / 7
			if wks > 1 {
				return "\(wks) weeks ago on " + self.friendlyDateFull()
			}
			return "1 week ago"
		}
		return self.friendlyDateFull() + " (\(-dd) days time)"
	}
	
	func absoluteDate(_ offset: Int = 0) -> Date {
		return self.disregardTime().addDays(offset)
	}
	
	func addDays(_ add: Int) -> Date {
		return Calendar.current.date(byAdding: .day, value: add, to: self)!
	}
	func addMonths(_ add: Int) -> Date {
		return Calendar.current.date(byAdding: .month, value: add, to: self)!
	}
	func addYears(_ add: Int) -> Date {
		return Calendar.current.date(byAdding: .year, value: add, to: self)!
	}

	func toString(_ format: String) -> String {
		let df = DateFormatter()
		df.dateFormat = format
		return df.string(from: self)
	}
}

public extension String {
	func toDate(_ format: String) -> Date? {
		let df = DateFormatter()
		df.dateFormat = format
		return df.date(from: self)
	}
}
