//
//  InfoProvider.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 12/10/2023.
//

import Foundation

//protocol InfoProvider {
//	func lookupChord(collection: String, name: String, version: Int?) -> Chord?
//	func getLatestValue(command: MusicCSV.Command) -> String
//}
//
//class LookupCommand {
//	init(columns: [MusicCSV.Field : Int], data: [String]) {
//		self.columns = columns
//		self.data = data
//	}
//	
//	var columns: [MusicCSV.Field:Int] = [:]
//	
//	var data: [String]
//	
//	func get<T>(_ field: MusicCSV.Field, _ defaultValue: T?) -> T? {
//		guard columns.keys.contains(field) else { return defaultValue }
//		let index = columns[field]!
//		if (0..<data.count).contains(index) {
//			if let ret = data[index] as? T {
//				return ret
//			}
//			
//		}
//		return defaultValue
//	}
//	
//	private var storage: [MusicCSV.Command: StoreCommands.StoreCommand] = [:]
//	
//	func store(command: MusicCSV.Command, value: StoreCommands.StoreCommand) {
//		storage.removeValue(forKey: command)
//		storage[command] = value
//	}
//	
//	func retrieve(command: MusicCSV.Command, defaultValue: StoreCommands.StoreCommand?) -> StoreCommands.StoreCommand? {
//		return storage[command] ?? defaultValue
//	}
//}



