//
//  Logging+Extensions.swift
//  MyMusic
//
//  Created by Matt Hogg on 13/05/2023.
//

import Foundation

protocol Logable {
	func log()
}

extension Artist : Logable {
	func log() {
		Log.funcParams("::Artist", items: [
			"name": self.name,
			"albumsPerformedOn":self.albumsPerformedOn?.map({($0 as? Album)?.name ?? ""}).joined(separator: ", ")
		])
	}
}


extension Album : Logable {
	func log() {
		Log.funcParams("::Album", items: [
			"name": self.name,
			"releaseYear": self.releaseYear,
			"sortOrder": self.sortOrder
		])
	}
}

extension Track: Logable {
	func log() {
		Log.funcParams("::Track", items: [
			"name": self.name,
			"trackNo": self.trackNo,
			"type": self.type,
			"authors": self.authors?.map({($0 as? Artist)?.name ?? ""}).joined(separator: ", ")
		])
	}
}
