//
//  ListTest.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 09/06/2021.
//  Copyright © 2021 Matt Hogg. All rights reserved.
//

import SwiftUI
import UsefulExtensions

struct Person: Identifiable {
	let id = UUID()
	var name: String
	var dob: Date
	
	func age() -> Int {
		return dob.getAge().year
	}
}

struct ListTest: View {
	
	var names = [
		Person(name: "Matt", dob: Date.fromYMD(year: 1974, month: 2, day: 12)!),
		Person(name: "Laurie", dob: Date.fromYMD(year: 1972, month: 12, day: 4)!),
		Person(name: "George", dob: Date.fromYMD(year: 2004, month: 2, day: 4)!),
		Person(name: "Pooh", dob: Date.fromYMD(year: 2013, month: 1, day: 1)!),
		Person(name: "Penny", dob: Date.fromYMD(year: 2014, month: 1, day: 1)!)]
    var body: some View {
		//NavigationView {
			List {
				ForEach(names.sorted(by: { p1, p2 in
					return p1.name < p2.name
				})) { person in
					PersonView(person: person)
				}
			}
		//}
	}
}

struct PersonView : View {
	var person: Person
	
	var body : some View {
		HStack {
			Text(person.name)
				.font(.headline)
			Spacer()
			//Text("\(person.age()) days")
		}
	}
}

struct ListTest_Previews: PreviewProvider {
    static var previews: some View {
        ListTest()
    }
}

extension Date {
	/*
	How to calculate an age
	As we are given the result from TimeInterval in seconds it's quite a challenge to calculate day differences without the original date
	*/
	
	func getAge(_ other: Date? = nil) -> (day: Int, month: Int, year: Int) {
		let dt = other ?? Date()
		//returns (day, months, years)
		let parts = Calendar.current.dateComponents([.year, .month, .day], from: dt, to: Date())
		return (parts.day!, parts.month!, parts.year!)
	}
	
	static func fromYMD(year: Int, month: Int, day: Int) -> Date? {
		guard month > 0 && month < 13 else {
			return nil
		}
		guard day > 0 && day < 32 else {
			return nil
		}
		
		var ret : Date? = Date()
		ret = Calendar.current.date(bySetting: .year, value: year, of: ret!)!
		ret = Calendar.current.date(bySetting: .month, value: month, of: ret!)!
		ret = Calendar.current.date(bySetting: .day, value: day, of: ret!)
		return ret
	}
}

