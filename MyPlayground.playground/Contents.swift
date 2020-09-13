import Cocoa
//import UIKit
import PlaygroundSupport

struct UKBankHolidays : Codable {
	var NI : BankHoliday
	var Scotland : BankHoliday
	var EnglandWales : BankHoliday
	
	enum CodingKeys : String, CodingKey {
		case NI = "northern-ireland"
		case Scotland = "scotland"
		case EnglandWales = "england-and-wales"
	}
}

struct BankHoliday : Codable {
	var division : String
	var events : [BankHolidayEvent]
}

struct BankHolidayEvent : Codable {
	var title : String
	var date : String
	var notes : String
	var bunting : Bool
	
	var typedDate : Date? {
		get {
			return date.asDate()
		}
	}
}

extension String {
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

extension Date {
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


PlaygroundPage.current.needsIndefiniteExecution = true

var json: String = ""

if let url = URL(string: "http://www.gov.uk/bank-holidays.json") {
	URLSession.shared.dataTask(with: url) { data, response, error in
		if let data = data {
			do {
				let res = try JSONDecoder().decode(UKBankHolidays.self, from: data)
				res.EnglandWales.events.filter { (e) -> Bool in
					return e.date.asDate()?.year == 2020
				}.sorted { (ev1, ev2) -> Bool in
					if let td1 = ev1.typedDate, let td2 = ev2.typedDate {
						return td1 < td2
					}
					return false
				}.forEach { (ev) in
					print("\(ev.date) - \(ev.title)")
				}
			} catch let error {
				print(error)
			}
		}
	}.resume()
}

var str = "Hello, playground"

