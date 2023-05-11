//
//  Extensions.swift
//  MyMusic
//
//  Created by Matt Hogg on 09/05/2023.
//

import Foundation
import AppKit
import UsefulExtensions

extension Artist {
	
	func tracksOrdered() -> [Track] {
		var ret : [Track] = []
		albumsOrdered().forEach { album in
			ret.append(contentsOf: album.tracksOrdered())
		}
		return ret.sorted { t1, t2 in
			let t1o = String(format: "%08d", (t1.album?.sortOrder ?? 0)) + String(format: "%08d", t1.trackNo)
			let t2o = String(format: "%08d", (t2.album?.sortOrder ?? 0)) + String(format: "%08d", t2.trackNo)
			return t1o < t2o
		}
	}

	func albumsOrdered() -> [Album] {
		return albumsPerformedOn?.allObjects.compactMap({$0 as? Album}).sorted(by: {$0.sortOrder < $1.sortOrder}) ?? []
	}
	
	static func getAll(_ context: NSManagedObjectContext? = nil) -> [Artist] {
		let context = context ?? PersistenceController.shared.container.viewContext
		let request = NSFetchRequest<Self>(entityName: "\(Self.self)")
		do {
			return try context.fetch(request)
		}
		catch {}
		return []
	}
	
	@discardableResult
	static func assert(_ name: String, _ context: NSManagedObjectContext? = nil, completion: ((Artist, Bool) -> Void)?) -> Artist {
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
		let artist = Artist(context: context)
		artist.name = name
		if let extra = completion {
			extra(artist, true)
		}
		return artist
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
		if let candidate = album.tracks?.allObjects.compactMap({$0 as? Track}).first(where: {$0.name!.implies(name)}) {
			if let callback = completion {
				callback(candidate, false)
			}
			return candidate
		}
		let context = album.managedObjectContext ?? PersistenceController.shared.container.viewContext
		let track = Track(context: context)
		track.name = name
		album.addToTracks(track)
		if let extra = completion {
			extra(track, true)
		}
		return track
	}
}
