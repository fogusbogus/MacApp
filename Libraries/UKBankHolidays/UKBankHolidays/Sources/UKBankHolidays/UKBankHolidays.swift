//
//  UKBankHolidays.swift
//  UKBankHolidays
//
//  Created by Matt Hogg on 13/09/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import Foundation

public struct UKBankHoliday : Codable {
	public var NI : BankHoliday
	public var Scotland : BankHoliday
	public var EnglandWales : BankHoliday
	
	enum CodingKeys : String, CodingKey {
		case NI = "northern-ireland"
		case Scotland = "scotland"
		case EnglandWales = "england-and-wales"
	}
}

public struct BankHoliday : Codable {
	public var division : String
	public var events : [BankHolidayEvent]
}

public struct BankHolidayEvent : Codable, Comparable {
	public static func < (lhs: BankHolidayEvent, rhs: BankHolidayEvent) -> Bool {
		return lhs.date < rhs.date
	}
	public static func == (lhs: BankHolidayEvent, rhs: BankHolidayEvent) -> Bool {
		return lhs.date == rhs.date
	}
	public static func > (lhs: BankHolidayEvent, rhs: BankHolidayEvent) -> Bool {
		return lhs.date > rhs.date
	}
	
	public var title : String
	public var date : String
	public var notes : String
	public var bunting : Bool
	
	public var typedDate : Date? {
		get {
			return date.asDate()
		}
	}
}

private extension Date {
	var year : Int {
		get {
			let cal = Calendar.current
			return cal.component(.year, from: self)
		}
		set {
			let cal = Calendar.current
			self = cal.date(bySetting: .year, value: newValue, of: self) ?? self
		}
	}
	
	var month : Int {
		get {
			let cal = Calendar.current
			return cal.component(.month, from: self)
		}
		set {
			let cal = Calendar.current
			self = cal.date(bySetting: .month, value: newValue, of: self) ?? self
		}
	}
	
	var day : Int {
		get {
			let cal = Calendar.current
			return cal.component(.day, from: self)
		}
		set {
			let cal = Calendar.current
			self = cal.date(bySetting: .day, value: newValue, of: self) ?? self
		}
	}
	
	var hour : Int {
		get {
			let cal = Calendar.current
			return cal.component(.hour, from: self)
		}
		set {
			let cal = Calendar.current
			self = cal.date(bySetting: .hour, value: newValue, of: self) ?? self
		}
	}
	
	var minute : Int {
		get {
			let cal = Calendar.current
			return cal.component(.minute, from: self)
		}
		set {
			let cal = Calendar.current
			self = cal.date(bySetting: .minute, value: newValue, of: self) ?? self
		}
	}
	
	var second : Int {
		get {
			let cal = Calendar.current
			return cal.component(.second, from: self)
		}
		set {
			let cal = Calendar.current
			self = cal.date(bySetting: .second, value: newValue, of: self) ?? self
		}
	}
	
	var nanosecond : Int {
		get {
			let cal = Calendar.current
			return cal.component(.nanosecond, from: self)
		}
		set {
			let cal = Calendar.current
			self = cal.date(bySetting: .nanosecond, value: newValue, of: self) ?? self
		}
	}
	
	var timeZone : Int {
		get {
			let cal = Calendar.current
			return cal.component(.timeZone, from: self)
		}
		set {
			let cal = Calendar.current
			self = cal.date(bySetting: .timeZone, value: newValue, of: self) ?? self
		}
	}
	
	var dmy : (Int,Int,Int) {
		get {
			return (self.year, self.month, self.day)
		}
		set {
			let cal = Calendar.current
			self = cal.date(bySetting: .year, value: newValue.0, of: self) ?? self
			self = cal.date(bySetting: .month, value: newValue.1, of: self) ?? self
			self = cal.date(bySetting: .day, value: newValue.2, of: self) ?? self
		}
	}
	
	var hms : (Int,Int,Int) {
		get {
			return (self.hour, self.minute, self.second)
		}
		set {
			let cal = Calendar.current
			self = cal.date(bySetting: .hour, value: newValue.0, of: self) ?? self
			self = cal.date(bySetting: .minute, value: newValue.1, of: self) ?? self
			self = cal.date(bySetting: .second, value: newValue.2, of: self) ?? self
		}
	}
	
	var hmsn : (Int,Int,Int, Int) {
		get {
			return (self.hour, self.minute, self.second, self.nanosecond)
		}
		set {
			let cal = Calendar.current
			self = cal.date(bySetting: .hour, value: newValue.0, of: self) ?? self
			self = cal.date(bySetting: .minute, value: newValue.1, of: self) ?? self
			self = cal.date(bySetting: .second, value: newValue.2, of: self) ?? self
			self = cal.date(bySetting: .nanosecond, value: newValue.3, of: self) ?? self
		}
	}
}


private extension String {
	func asDate() -> Date? {
		let parts = self.split(separator: "-")
		if parts.count >= 3 {
			if let year = Int(parts[0]), let month = Int(parts[1]), let day = Int(parts[2]) {
				let cal = Calendar(identifier: .gregorian)
				let components = DateComponents(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
				return cal.date(from: components)
			}
		}
		return nil
	}
}

private extension Array where Element == BankHolidayEvent {
	mutating func appendUnique(_ contents: [BankHolidayEvent]) {
		contents.forEach { (event) in
			if !self.contains(where: { (el) -> Bool in
				return el.date == event.date
			}) {
				self.append(event)
			}
		}
	}
}

public class UKBankHolidays {
	
	public enum Division {
		case EnglandAndWales
		case Scotland
		case NorthernIreland
		case All
		case Weekends
	}
	
	public static func getHolidays(division: [Division]) -> [BankHolidayEvent] {
		
		var finished = false
		var ret : [BankHolidayEvent] = []
		
		if let url = URL(string: "http://www.gov.uk/bank-holidays.json") {
			
			URLSession.shared.dataTask(with: url) { data, response, error in
				if let data = data {
					do {
						let res = try JSONDecoder().decode(UKBankHoliday.self, from: data)
						
						if division.contains(.All) {
							ret.appendUnique(res.EnglandWales.events)
							ret.appendUnique(res.Scotland.events)
							ret.appendUnique(res.NI.events)
						}
						
						if division.contains(.EnglandAndWales) {
							ret.appendUnique(res.EnglandWales.events)
						}
						if division.contains(.Scotland) {
							ret.appendUnique(res.Scotland.events)
						}
						if division.contains(.NorthernIreland) {
							ret.appendUnique(res.NI.events)
						}
						
						if division.contains(.Weekends) && ret.count > 0 {
							//This is special processing
							var startDate = ret.min()!.typedDate!
							let endYear = ret.max()!.typedDate!.year + 1
							let cal = Calendar.current
							
							while startDate.year < endYear {
								
								if cal.isDateInWeekend(startDate) {
									let df = DateFormatter()
									df.dateFormat = "yyyy-MM-dd"
									
									ret.appendUnique([BankHolidayEvent(title: cal.standaloneWeekdaySymbols[cal.component(.weekday, from: startDate)], date: df.string(from: startDate), notes: "Weekend", bunting: false)])
								}
								startDate = cal.date(byAdding: .day, value: 1, to: startDate)!
							}
							
						}
					} catch let error {
						print(error)
					}
					finished = true
				}
			}.resume()
		}
		while !finished {}
		return ret
	}
}
