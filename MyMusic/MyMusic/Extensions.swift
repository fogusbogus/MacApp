//
//  Extensions.swift
//  MyMusic
//
//  Created by Matt Hogg on 09/05/2023.
//

import Foundation
import AppKit
import UsefulExtensions
import LoggingLib

class Log : ConsoleLog {
	
}

extension Artist {
	
	func tracksOrdered() -> [Track] {
		Log.return {
			var ret : [Track] = []
			albumsOrdered().forEach { album in
				ret.append(contentsOf: album.tracksOrdered())
			}
			return ret.sorted { t1, t2 in
				let t1o = String(format: "%08d", (t1.album?.sortOrder ?? 0)) + String(format: "%08d", t1.trackNo)
				let t2o = String(format: "%08d", (t2.album?.sortOrder ?? 0)) + String(format: "%08d", t2.trackNo)
				return t1o < t2o
			}
		} pre: {
			Log.funcParams("Artist::tracksOrdered()", items: [:])
		} post: { v in
			Log.log("\(v.count) track(s) returned")
		}
	}

	func albumsOrdered() -> [Album] {
		Log.return {
			return albumsPerformedOn?.allObjects.compactMap({$0 as? Album}).sorted(by: {$0.sortOrder < $1.sortOrder}) ?? []
		} pre: {
			Log.funcParams("Artist::albumsOrdered()", items: [:])
		} post: { v in
			Log.log("\(v.count) album(s) returned")
		}

	}
	
	func hasAlbums() -> Bool {
		Log.return {
			return albumsPerformedOn?.count ?? 0 > 0
		} pre: {
			
		} post: { _, _ in
			
		}

	}
	
	static func getAll(_ context: NSManagedObjectContext? = nil) -> [Artist] {
		Log.return {
			let context = context ?? PersistenceController.shared.container.viewContext
			let request = NSFetchRequest<Self>(entityName: "\(Self.self)")
			do {
				return try context.fetch(request)
			}
			catch {
				Log.error(error)
			}
			return []
		} pre: {
			Log.log("")
			Log.log(Log.label("Artist::getAll()"))
		} post: { v in
			Log.log("\(v.count) album(s) returned")
		}
	}
	
	@discardableResult
	static func assert(_ name: String, _ context: NSManagedObjectContext? = nil, completion: ((Artist, Bool) -> Void)?) -> Artist {
		Log.return {
			let context = context ?? PersistenceController.shared.container.viewContext
			let request = NSFetchRequest<Self>(entityName: "\(Self.self)")
			let pred = NSPredicate(format: "name like %@", name)
			request.predicate = pred
			do {
				let coll = try context.fetch(request)
				if let ret = coll.first {
					if let callback = completion {
						callback(ret, false)
					}
					return ret
				}
			}
			catch {
				Log.error(error)
			}
			let artist = Artist(context: context)
			artist.name = name
			if let extra = completion {
				extra(artist, true)
			}
			return artist
		} pre: {
			Log.funcParams("Artist::assert", items: ["name":name, "context":context != nil, "completion":completion != nil])
		} post: { v in
			Log.log("\"\(v.name ?? "")\" returned")
		}

	}
	
	@discardableResult
	static func assertMany(_ names: [String], _ context: NSManagedObjectContext? = nil, completion: ((Artist, Bool) -> Void)? = nil) -> [Artist] {
		var ret : [Artist] = []
		names.filter({!$0.isEmptyOrWhitespace()}).forEach({ret.append(Artist.assert($0, context, completion: completion))})
		return ret
	}
}

extension Album {
	func tracksOrdered() -> [Track] {
		return tracks?.allObjects.compactMap({$0 as? Track}).sorted(by: {$0.trackNo < $1.trackNo}) ?? []
	}
	
	@discardableResult
	static func assert(_ name: String, _ context: NSManagedObjectContext? = nil, completion: ((Album, Bool) -> Void)?) -> Album {
		let context = context ?? PersistenceController.shared.container.viewContext
		let request = NSFetchRequest<Self>(entityName: "\(Self.self)")
		let pred = NSPredicate(format: "name like %@", name)
		request.predicate = pred
		do {
			let coll = try context.fetch(request)
			if let ret = coll.first {
				if let callback = completion {
					callback(ret, false)
				}
				return ret
			}
		}
		catch {
			
		}
		let album = Album(context: context)
		album.name = name
		if let extra = completion {
			extra(album, true)
		}
		return album
	}
	
	@discardableResult
	static func assert(_ name: String, artist: Artist, completion: ((Album, Bool) -> Void)?) -> Album {
		if let candidate = artist.albumsPerformedOn?.allObjects.compactMap({$0 as? Album}).first(where: {$0.name!.implies(name)}) {
			if let callback = completion {
				callback(candidate, false)
			}
			return candidate
		}
		let context = artist.managedObjectContext ?? PersistenceController.shared.container.viewContext
		let album = Album(context: context)
		album.name = name
		album.sortOrder = Int32((artist.albumsPerformedOn?.count ?? 0) + 1)
		artist.addToAlbumsPerformedOn(album)
		if let extra = completion {
			extra(album, true)
		}
		return album
	}
}

extension Track {
	@discardableResult
	static func assert(_ name: String, album: Album, completion: ((Track, Bool) -> Void)?) -> Track {
		if var candidate = album.tracks?.allObjects.compactMap({$0 as? Track}).first(where: {$0.name!.implies(name)}) {
			if let callback = completion {
				callback(candidate, false)
				PersistenceController.shared.saveData()
			}
			return candidate
		}
		else {
			print("New track!")
		}
		let context = album.managedObjectContext ?? PersistenceController.shared.container.viewContext
		let track = Track(context: context)
		track.name = name
		album.addToTracks(track)
		if let extra = completion {
			extra(track, true)
			PersistenceController.shared.saveData()
		}
		return track
	}
	
	@discardableResult
	func assertAuthors(artists: [Artist]) -> [Artist] {
		Log.return {
			let alreadyEstablished = self.authors?.array.compactMap({$0 as? Artist}) ?? []
			artists.forEach { artist in
				if !alreadyEstablished.contains(obj: artist) {
					addToAuthors(artist)
				}
			}
			return self.authors?.array.compactMap({$0 as? Artist}) ?? []
		} pre: {
			Log.funcParams("assertAuthors", items: [
				"artists":artists.map({ $0.name ?? "" }).joined(separator: ", ")
			])
		} post: { authors in
			Log.funcParams("RESULTS (assertAuthors)", items: [
				"Return Value":authors.map({$0.name ?? ""}).joined(separator: ", ")
			])
		}

	}
	
	@discardableResult
	func removeAllAuthors() -> [Artist] {
		let artists = self.authors?.array.compactMap({$0 as? Artist}) ?? []
		let this = self
		artists.forEach({this.removeFromAuthors($0)})
		return artists
	}
	@discardableResult
	func removeAllLyricists() -> [Artist] {
		let artists = self.lyricists?.array.compactMap({$0 as? Artist}) ?? []
		let this = self
		artists.forEach({this.removeFromLyricists($0)})
		return artists
	}
	
	@discardableResult
	func assertLyricists(lyricists: [Artist]) -> [Artist] {
		Log.return {
			let alreadyEstablished = self.lyricists?.array.compactMap({$0 as? Artist}) ?? []
			lyricists.forEach { artist in
				if !alreadyEstablished.contains(obj: artist) {
					addToLyricists(artist)
				}
			}
			return self.lyricists?.array.compactMap({$0 as? Artist}) ?? []
		} pre: {
			Log.funcParams("assertAuthors", items: [
				"artists":lyricists.map({ $0.name ?? "" }).joined(separator: ", ")
			])
		} post: { authors in
			Log.funcParams("RESULTS (assertAuthors)", items: [
				"Return Value":authors.map({$0.name ?? ""}).joined(separator: ", ")
			])
		}
		
	}
}
