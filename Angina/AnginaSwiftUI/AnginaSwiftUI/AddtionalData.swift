//
//  File.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 15/02/2021.
//  Copyright © 2021 Matt Hogg. All rights reserved.
//

import Foundation

protocol AdditionalDataProvider : Codable {
	var date : Date { get set }
	
	
}

class ADBase : AdditionalDataProvider {

	enum CodingKeys : CodingKey {
		case date
	}

	internal init(date: Date) {
		self.date = date
	}
	
	var date: Date

}

extension ADBase {
	
	func encodeJson() -> String {
		let e = JSONEncoder()
		e.dateEncodingStrategy = .iso8601
		e.keyEncodingStrategy = .useDefaultKeys
		do {
			let data = try e.encode(self)
			return String(data: data, encoding: .utf8) ?? ""
			
		}
		catch {
			return ""
		}
	}
	
	func decode(data: String) -> Self? {
		if let newData = data.data(using: .utf8) {
			return decode(data: newData)
		}
		return nil
	}
	
	func decode(data: Data) -> Self? {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		decoder.keyDecodingStrategy = .useDefaultKeys
		
		do {
			let decoded = try decoder.decode(Self.self, from: data)
			return decoded
		}
		catch {
			print("Failed to decode JSON for \(Self.self)")
		}
		return nil
	}
}

class ADBloodPressure : ADBase {
	
	enum CodingKeys : CodingKey {
		case date, systolic, diastolic
	}

	internal init(systolic: Int, diastolic: Int) {
		self.systolic = systolic
		self.diastolic = diastolic
		super.init(date: Date())
	}
	
	required init(from decoder: Decoder) throws {
		fatalError("init(from:) has not been implemented")
	}
	
	var systolic  : Int
	var diastolic : Int
	
}

class ADHeartRate : ADBase {
	
	enum CodingKeys : CodingKey {
		case date, bpm
	}

	internal init(BPM: Int) {
		self.BPM = BPM
		super.init(date: Date())
	}
	
	required init(from decoder: Decoder) throws {
		fatalError("init(from:) has not been implemented")
	}
	
	var BPM : Int
}

class ADFood : ADBase {
	
	enum CodingKeys : CodingKey {
		case date, size
	}

	internal init(size: String) {
		self.size = size
		super.init(date: Date())
	}
	
	required init(from decoder: Decoder) throws {
		fatalError("init(from:) has not been implemented")
	}
	
	var size : String
}

class ADMedication : ADBase {
	
	enum CodingKeys : CodingKey {
		case date, am, pm, spray
	}

	internal init(am: Bool, pm: Bool, spray: Bool) {
		self.am = am
		self.pm = pm
		self.spray = spray
		super.init(date: Date())
	}
	
	required init(from decoder: Decoder) throws {
		fatalError("init(from:) has not been implemented")
	}
	
	var am : Bool
	var pm : Bool
	var spray : Bool
}

class ADMood : ADBase {
	
	enum CodingKeys : CodingKey {
		case date, percent, notes
	}

	internal init(percent: Int, notes: String) {
		self.percent = percent
		self.notes = notes
		super.init(date: Date())
	}
	
	required init(from decoder: Decoder) throws {
		fatalError("init(from:) has not been implemented")
	}
	
	var percent : Int
	var notes   : String
}

class ADNotes : ADBase {
	
	enum CodingKeys : CodingKey {
		case date, notes
	}

	internal init(notes: String) {
		self.notes = notes
		super.init(date: Date())
	}
	
	required init(from decoder: Decoder) throws {
		fatalError("init(from:) has not been implemented")
	}
	
	var notes : String
}

//enum AddtionalData {
//	case bloodPressure(sys: Int, dia: Int, bpm: Int)
//	case heartRate(bpm: Int)
//	case food(size: FoodSize)
//	case medication(am: Bool, pm: Bool, spray: Bool)
//	case mood(percent: Float)
//	case notes(text: String)
//
//	func toData() -> String {
//		var dict : Dictionary<String, Any> = Dictionary<String, Any>()
//		switch self {
//
//			case .bloodPressure(sys: let sys, dia: let dia, bpm: let bpm):
//				dict["sys"] = sys
//				dict["dia"] = dia
//				dict["bpm"] = bpm
//				break
//			case .heartRate(bpm: let bpm):
//				dict["bpm"] = bpm
//				break
//			case .food(size: let size):
//				dict["food"] = size
//				break
//			case .medication(am: let am, pm: let pm, spray: let spray):
//				dict["am"] = am
//				dict["pm"] = pm
//				dict["spray"] = spray
//				break
//			case .mood(percent: let percent):
//				dict["percent"] = percent
//				break
//			case .notes(text: let text):
//				dict["notes"] = text
//				break
//		}
//	}
//}
//
//enum FoodSize {
//	case small
//	case medium
//	case large
//}

