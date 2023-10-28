//
//  ChordCSV.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 11/10/2023.
//

import Foundation

extension CSV {
	public class ChordCSV {
		static var testData =  "Collection,Name,Description,Version,Barre,F1,F2,F3,F4,F5,F6\nIntro,Ab,,,,-1,6,6,8,-1,-1\n,Eb,,,,-1,6,8,8,-1,-1\n,Bb,,,,6,8,8,-1,-1,-1\n,Gb,,,,2,4,4,-1,-1,-1\n,,,,,,,,,,\nVerse,Bb,,,,6,8,8,-1,-1,-1\n,,,,,,,,,,\nChorus,Ab5,,,,4,6,6,,,\n,Bb5,,,,6,8,8,,,\n,G5,,,,3,5,5,,,\n,Eb5,,,,,6,8,8,,\n,,,,,,,,,,\nBridge,G5,,,,3,5,5,,,\n,Bb/Eb,,,,,6,8,7,6,6\n,Dm7,,,,,5,7,5,6,5\n,Cm7,,,,,3,5,3,4,3\n,F,,,,,,3,5,6,5\n,,,,,,,,,,\nInstrumental,D7sus4,,,,,,0,2,1,3\n,C,,,,,3,2,0,1,0\n,D,,,,,,0,2,3,2\n,Am7,,,,,0,2,0,1,0\n,Bm7,,,2,,0,2,0,1,0\n"
		
		enum Field: String, CaseIterable {
			case collection = "Collection~Col~Coll"
			case name = "Name"
			case desc = "Description~Desc"
			case version = "Version~Ver~V"
			case barre = "Barre~Bar~Origin~Open~Capo"
			case f1 = "F1~Fret1~Fret 1"
			case f2 = "F2~Fret2~Fret 2"
			case f3 = "F3~Fret3~Fret 3"
			case f4 = "F4~Fret4~Fret 4"
			case f5 = "F5~Fret5~Fret 5"
			case f6 = "F6~Fret6~Fret 6"
			
			enum Errors: Error {
				case noMatchFound
			}
			
			static func match(_ text: String) throws -> Field {
				let ret : Field? = Field.allCases.first (where: { field in
					let splits = field.rawValue.split(separator: "~").map {String($0)}
					return splits.first(where: {$0.lowercased() == text.lowercased()}) != nil
				})
				if let value = ret {
					return value
				}
				throw Errors.noMatchFound
			}
		}
		
		public static func readChordsFromCSV(csv: String) -> [Chord] {
			var data = CSVTranslation.getArrayFromCSVContent(csv: csv, options: CSVTranslation.Options(alignColumnCount: true)).filter { row in
				// rows beginning with a semi-colon can be looked upon as comments
				if row.first?.trimmingCharacters(in: .whitespaces).starts(with: ";") ?? false {
					return false
				}
				return row.contains(where: {$0.count > 0})
			}
			let headers = data.removeFirst()
			var cols: [Field:Int] = [:]
			headers.forEach { header in
				do {
					let field = try Field.match(header)
					cols[field] = headers.firstIndex(of: header)!
				}
				catch {
				}
			}
			if cols.count < Field.allCases.count {
				return []
			}
			
			if !cols.keys.containsAll([.collection, .f1, .f2, .f3, .f4, .f5, .f6, .name]) {
				return []
			}
			
			var ret: [Chord] = []
			var lastCollection = ""
			data.forEach { row in
				ret.append(Chord({ chord in
					chord.name = row[cols[.name]!]
					chord.collection = row[cols[.collection]!]
					if chord.collection == "" {
						chord.collection = lastCollection
					}
					else {
						lastCollection = chord.collection
					}
					chord.desc = row[cols[.desc]!]
					chord.frets.append(Int(row[cols[.f1]!]) ?? -1)
					chord.frets.append(Int(row[cols[.f2]!]) ?? -1)
					chord.frets.append(Int(row[cols[.f3]!]) ?? -1)
					chord.frets.append(Int(row[cols[.f4]!]) ?? -1)
					chord.frets.append(Int(row[cols[.f5]!]) ?? -1)
					chord.frets.append(Int(row[cols[.f6]!]) ?? -1)
					
					//Barre can force the open fret to be greater than zero
					if cols.keys.contains(.barre) {
						let barre = Int(row[cols[.barre]!]) ?? 0
						if barre > 0 {
							chord.frets = chord.frets.map({ fret in
								if fret >= 0 {
									return fret + barre
								}
								return -1
							})
						}
					}
					
					chord.version = Int(row[cols[.version]!]) ?? getVersionFor(collection: ret.filter {$0.collection.localizedCaseInsensitiveCompare(chord.collection) == .orderedSame}, name: chord.name)
				}))
			}
			return ret
		}
		
		static func getVersionFor(collection: [Chord], name: String) -> Int {
			return collection.filter {$0.name.lowercased() == name.lowercased()}.count + 1
		}
	}
}

extension Collection where Element: Equatable {
	func containsAll(_ elements: [Element]) -> Bool {
		return elements.allSatisfy {self.contains($0)}
	}
}
