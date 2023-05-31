//
//  NewPropertyRange.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 27/05/2023.
//

import SwiftUI
import MeasuringView

enum RangeFilterType : CaseIterable, Identifiable, CustomStringConvertible {
	case none, odds, evens
	
	var id: Self {self}

	var description: String {
		get {
			switch self {
				case .none:
					return "-"
				case .odds:
					return "Odd numbers only"
				case .evens:
					return "Even numbers only"
			}
		}
	}
	

	func process(items: [String]) -> [String] {
		guard self != .none else { return items }
		var ret : [String] = []
		items.forEach { item in
			if let num = Int(item) {
				if self == .odds && num % 2 == 1 {
					ret.append(item)
				}
				if self == .evens && num % 2 == 0 {
					ret.append(item)
				}
			}
		}
		return ret
	}
	
}

struct NewPropertyRange: View {
	
	init() {
		
	}
	init(subStreet: SubStreet?, street: Street?, delegate: NewPropertyRangeDelegate?) {
		self.subStreet = subStreet
		self.street = street
		self.delegate = delegate
	}
	
	var subStreet: SubStreet?
	var street: Street?
	var delegate: NewPropertyRangeDelegate?
	
	@State var filter: RangeFilterType = .none
	
	@ObservedObject var measure = MeasuringView()
	
	@State var range: String = ""
	
	private func getItems() -> [String] {
		let parts = range.splitToArray(",").map {$0.trim()}.filter {$0.length() > 0}
		var ret : [String] = []
		parts.forEach { part in
			if let num = Int(part) {
				ret.assert(part)
			}
			else {
				if part.contains("-") {
					let nums = part.splitToArray("-").map {$0.trim()}.filter {$0.length() > 0}
					if nums.count > 1 {
						if let a = Int(nums[0]), let b = Int(nums[1]) {
							(a...b).forEach {ret.assert("\($0)")}
						}
					}
				}
				else {
					ret.assert(part)
				}
			}
		}
		ret.sort()
		return filter.process(items: ret)
	}
	
	func canOK() -> Bool {
		return warning.length() == 0
	}
	
	private var warning: String {
		get {
			//Need to do some kind of validation
			let parts = range.splitToArray(",").map {$0.trim()}.filter {$0.length() > 0}
			if parts.count == 0 {
				return "No range has been specified"
			}
			var msgs : [String] = []
			parts.forEach { part in
				if let num = Int(part) {
					if num < 1 {
						msgs.append("Number must be 1 or more")
					}
				} else {
					if part.contains("-") {
						let nums = part.splitToArray("-").map {$0.trim()}.filter {$0.length() > 0}
						if nums.count != 2 {
							msgs.append("Number range should only have a start and end")
						}
						else {
							if let n1 = Int(nums[0]), let n2 = Int(nums[1]) {
								if n1 >= n2 {
									msgs.append("Number range has conflicting values")
								}
								else {
									if n2 - n1 > 100 {
										msgs.append("Number range is more than 100 properties. Please refactor and repeat if necessary")
									}
								}
							}
						}
					}
				}
			}
			return msgs.first ?? ""
		}
	}
		
    var body: some View {
		VStack(alignment: .center, spacing: 4) {
			Group {
				HStack {
					Text("New Range of Properties")
						.font(.largeTitle)
					Spacer()
				}
				Spacer()
					.frame(height: 16)
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Street:")
						.decidesWidthOf(measure, key: "LABEL", alignment: .trailing)
					Text(street?.name ?? subStreet?.street?.name ?? "<Unknown Street>").bold()
					Spacer()
				}
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Substreet:")
						.decidesWidthOf(measure, key: "LABEL", alignment: .trailing)
					Text(subStreet?.name ?? "<Unknown Street>").bold()
					Spacer()
				}
			}
			Spacer()
				.frame(height: 24)
			
			HStack(alignment: .firstTextBaseline, spacing: 8) {
				Text("Ranges:")
					.decidesWidthOf(measure, key: "LABEL", alignment: .trailing)
				TextField("e.g. 1-5, 10, House name 1, House name 2", text: $range)
			}
			Spacer()
				.frame(height: 24)
			HStack(alignment: .firstTextBaseline, spacing: 8) {
				Text("Filter:")
					.decidesWidthOf(measure, key: "LABEL", alignment: .trailing)
				Picker("", selection: $filter) {
					ForEach(RangeFilterType.allCases) { f in
						Text(String(describing: f))
					}
				}
				Spacer()
			}
			Spacer()
				.frame(height: 24)
			HStack(alignment:.center) {
				if warning != "" {
					Text("⚠️")
					Text(warning)
				}
				Spacer()
				Button("OK") {
					delegate?.okNew(subStreet: subStreet, street: street, items: getItems())
				}
				.disabled(!canOK())
				Button("Cancel") {
					delegate?.cancelNew(substreet: subStreet, street: street)
				}
			}
			.frame(alignment: .trailing)
		}
		.padding()
    }
}

protocol NewPropertyRangeDelegate {
	func cancelNew(substreet: SubStreet?, street: Street?)
	func okNew(subStreet: SubStreet?, street: Street?, items: [String])
}


struct NewPropertyRange_Previews: PreviewProvider {
    static var previews: some View {
        NewPropertyRange()
    }
}
