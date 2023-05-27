//
//  Persistence.swift
//  MyMusic
//
//  Created by Matt Hogg on 09/05/2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
		
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Artist(context: viewContext)
            //newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer
	
	func addTracks(album: Album, titles: String...) {
		var trackNo = (album.tracksOrdered().map({$0.trackNo}).max() ?? 0)+1
		titles.forEach { track in
			Track.assert(track, album: album) { trk, isNew in
				if isNew {
					trk.trackNo = Int32(trackNo)
					trackNo += 1
				}
			}
		}
	}
	
	func saveData() {
		Log.process("SAVING DATA") {
			do {
				try container.viewContext.save()
			}
			catch {
				Log.error(error)
			}
		}
	}
		
	func addTracks(album: Album, titles: [String], completion: ((Track) -> Void)? = nil) {
		Log.funcParams("Persistence::addTracks", items: [
			"album":album.name,
			"titles":titles.joined(separator: ", "),
			"completion": completion != nil
		])
		var trackNo = (album.tracksOrdered().map({$0.trackNo}).max() ?? 0)+1
		Log.log("TrackNo calculated as \(trackNo)")
		Log.process("Processing tracks") {
			titles.forEach { track in
				Log.log("Processing track \(track)")
				Track.assert(track, album: album) { trk, isNew in
					if isNew {
						Log.log("Track is NEW")
						trk.trackNo = Int32(trackNo)
						trackNo += 1
					}
					if let complete = completion {
						Log.process("Calling completion...") {
							complete(trk)
						}
						Log.log("...done")
					}
				}
			}
		}
	}
	
	func seedData() {
		
//		let all = Artist.getAll()
//		all.forEach({PersistenceController.shared.container.viewContext.delete($0)})
//		try? PersistenceController.shared.container.viewContext.save()
		
		let Banks = "Tony Banks"
		let Gabriel = "Peter Gabriel"
		let Rutherford = "Mike Rutherford"
		let Collins = "Phil Collins"
		let Hackett = "Steve Hackett"
		let Phillips = "Anthony Phillips"
		
//		Artist.assert("Genesis") { genesis, isNew in
//			Album.assert("From Genesis To Revelation", artist: genesis) { fgtr, isNew in
//				fgtr.releaseYear = 1969
//				addTracks(album: fgtr, titles: [
//					"Where The Sour Turns to Sweet",
//					"In the Beginning",
//					"Fireside Song",
//					"The Serpent",
//					"Am I Very Wrong?",
//					"Into the Wilderness",
//					"The Conqueror",
//					"In Hiding",
//					"One Day",
//					"Window",
//					"In Limbo",
//					"The Silent Sun",
//					"A Place to Call My Own"
//				]) { track in
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					track.assertAuthors(artists: Artist.assertMany([Banks, Rutherford, Gabriel, Phillips]))
//					track.assertLyricists(lyricists: Artist.assertMany([Banks, Rutherford, Gabriel, Phillips]))
//					track.log()
//				}
//			}
//
//			Album.assert("Trespass", artist: genesis) { album, isNew in
//				album.releaseYear = 1970
//				addTracks(album: album, titles: [
//					"Looking for Someone",
//					"White Mountain",
//					"Visions of Angels",
//					"Stagnation",
//					"Dusk",
//					"The Knife"
//				]) { track in
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					switch track.trackNo {
//						case 1,4:
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 2:
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//						case 3,5:
//							track.assertLyricists(lyricists: Artist.assertMany([Phillips]))
//						case 6:
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel, Phillips]))
//						default:
//							break
//					}
//					track.assertAuthors(artists: Artist.assertMany([Banks, Rutherford, Gabriel, Phillips]))
//					track.log()
//				}
//			}
//
//			Album.assert("Nursery Cryme", artist: genesis) { album, isNew in
//				album.releaseYear = 1971
//				addTracks(album: album, titles: [
//					"The Musical Box",
//					"For Absent Friends",
//					"The Return of the Giant Hogweed",
//					"Seven Stones",
//					"Harold the Barrel",
//					"Harlequin",
//					"The Fountain of Salmacis"
//				]) { track in
//					print(track.trackNo)
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					switch track.trackNo {
//						case 1:
//							track.assertAuthors(artists: Artist.assertMany([Rutherford, Phillips, Banks, Gabriel, Hackett]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 2:
//							track.assertAuthors(artists: Artist.assertMany([Hackett]))
//							track.assertLyricists(lyricists: Artist.assertMany([Hackett, Collins]))
//						case 3:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Gabriel, Rutherford, Hackett]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 4:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Hackett]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//						case 5:
//							track.assertAuthors(artists: Artist.assertMany([Gabriel]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel, Collins]))
//						case 6:
//							track.assertAuthors(artists: Artist.assertMany([Rutherford, Phillips]))
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford]))
//						case 7:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Rutherford, Hackett]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks, Gabriel]))
//
//						default:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Rutherford, Gabriel, Hackett, Collins]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks, Rutherford, Gabriel, Hackett, Collins]))
//					}
//					track.log()
//					PersistenceController.shared.saveData()
//					print("track now has \(track.authors?.count ?? 0) author(s)")
//				}
//			}
//
//			Album.assert("Foxtrot", artist: genesis) { album, isNew in
//				album.releaseYear = 1972
//				addTracks(album: album, titles: [
//					"Watcher of the Skies",
//					"Time Table",
//					"Get 'Em Out by Friday",
//					"Can-Utility and the Coastliners",
//					"Horizons",
//					"Supper's Ready"
//				]) { track in
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					switch track.trackNo {
//						case 1:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Rutherford, Gabriel, Collins]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks, Rutherford]))
//						case 2:
//							track.assertAuthors(artists: Artist.assertMany([Banks]))
//						case 3:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Gabriel, Rutherford, Hackett, "John Hackett"]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 4:
//							track.assertAuthors(artists: Artist.assertMany([Hackett, Banks, Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Hackett]))
//						case 5:
//							track.assertAuthors(artists: Artist.assertMany([Hackett]))
//						case 6:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Gabriel, Rutherford, Hackett, Collins]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						default:
//							break
//					}
//					track.log()
//					PersistenceController.shared.saveData()
//					print("track now has \(track.authors?.count ?? 0) author(s)")
//				}
//			}
//
//			Album.assert("Selling England By The Pound", artist: genesis) { album, isNew in
//				album.releaseYear = 1973
//				addTracks(album: album, titles: [
//					"Dancing with the Moonlit Knight",
//					"I Know What I Like (In Your Wardrobe)",
//					"Firth of Fifth",
//					"More Fool Me",
//					"The Battle of Epping Forest",
//					"After the Ordeal",
//					"The Cinema Show",
//					"Aisle of Plenty"
//				]) { track in
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					switch track.trackNo {
//						case 1:
//							track.assertAuthors(artists: Artist.assertMany([Gabriel, Hackett, Banks, Rutherford, Collins]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 2:
//							track.assertAuthors(artists: Artist.assertMany([Hackett, Banks, Gabriel]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 3:
//							track.assertAuthors(artists: Artist.assertMany([Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks, Rutherford]))
//						case 4:
//							track.assertAuthors(artists: Artist.assertMany([Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford, Collins]))
//						case 5:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Rutherford, Hackett, Gabriel, Collins]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 6:
//							track.assertAuthors(artists: Artist.assertMany([Hackett, Rutherford]))
//						case 7:
//							track.assertAuthors(artists: Artist.assertMany([Rutherford, Banks, Collins]))
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford, Banks]))
//						case 8:
//							track.assertAuthors(artists: Artist.assertMany([Gabriel]))
//						default:
//							break
//					}
//					track.log()
//					PersistenceController.shared.saveData()
//					print("track now has \(track.authors?.count ?? 0) author(s)")
//				}
//			}
//
//			Album.assert("The Lamb Lies Down On Broadway", artist: genesis) { album, isNew in
//				album.releaseYear = 1974
//				addTracks(album: album, titles: [
//					"The Lamb Lies Down on Broadway",
//					"Fly on a Windshield",
//					"Broadway Melody of 1974",
//					"Cuckoo Cocoon",
//					"In the Cage",
//					"The Grand Parade of Lifeless Packaging",
//					"Back in N.Y.C.",
//					"Hairless Heart",
//					"Counting Out Time",
//					"The Carpet Crawlers",
//					"The Chamber of 32 Doors",
//					"Lilywhite Lilith",
//					"The Waiting Room",
//					"Anyway",
//					"Here Comes the Supernatural Anaesthetist",
//					"The Lamia",
//					"Silent Sorrow in Empty Boats",
//					"The Colony of Slippermen (The Arrival/A Visit to the Doktor/The Raven)",
//					"Ravine",
//					"The Light Dies Down on Broadway",
//					"Riding the Scree",
//					"In the Rapids",
//					"it"
//				]) { track in
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					switch track.trackNo {
//						case 1:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Gabriel]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 2:
//							track.assertAuthors(artists: Artist.assertMany([Rutherford, Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 3:
//							track.assertAuthors(artists: Artist.assertMany([Rutherford, Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 4:
//							track.assertAuthors(artists: Artist.assertMany([Hackett, "John Hackett"]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 5:
//							track.assertAuthors(artists: Artist.assertMany([Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 6:
//							track.assertAuthors(artists: Artist.assertMany([Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 7:
//							track.assertAuthors(artists: Artist.assertMany([Rutherford, Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 8:
//							track.assertAuthors(artists: Artist.assertMany([Hackett, Banks]))
//						case 9:
//							track.assertAuthors(artists: Artist.assertMany([Gabriel]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 10:
//							track.assertAuthors(artists: Artist.assertMany([Gabriel, Banks, Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 11:
//							track.assertAuthors(artists: Artist.assertMany([Gabriel, Hackett, Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 12:
//							track.assertAuthors(artists: Artist.assertMany([Collins, Banks, Hackett, Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 13:
//							track.assertAuthors(artists: Artist.assertMany([Hackett, Banks, Collins, Gabriel, Rutherford]))
//						case 14:
//							track.assertAuthors(artists: Artist.assertMany([Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 15:
//							track.assertAuthors(artists: Artist.assertMany([Hackett]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 16:
//							track.assertAuthors(artists: Artist.assertMany([Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 17:
//							track.assertAuthors(artists: Artist.assertMany([Rutherford, Banks]))
//						case 18:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Hackett, Rutherford, Collins]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 19:
//							track.assertAuthors(artists: Artist.assertMany([Rutherford, Hackett]))
//						case 20:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Gabriel]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks, Rutherford]))
//						case 21:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 22:
//							track.assertAuthors(artists: Artist.assertMany([Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						case 23:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Hackett]))
//							track.assertLyricists(lyricists: Artist.assertMany([Gabriel]))
//						default:
//							break
//					}
//					track.log()
//					PersistenceController.shared.saveData()
//					print("track now has \(track.authors?.count ?? 0) author(s)")
//				}
//			}
//
//			Album.assert("A Trick Of The Tail", artist: genesis) { album, isNew in
//				album.releaseYear = 1976
//				addTracks(album: album, titles: [
//					"Dance on a Volcano",
//					"Entangled",
//					"Squonk",
//					"Mad Man Moon",
//					"Robbery, Assault & Battery",
//					"Ripples",
//					"A Trick of the Tail",
//					"Los Endos"
//				]){ track in
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					switch track.trackNo {
//						case 1:
//							track.assertAuthors(artists: Artist.assertMany([Rutherford, Banks, Hackett, Collins]))
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford, Banks, Hackett, Collins]))
//						case 2:
//							track.assertAuthors(artists: Artist.assertMany([Hackett, Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Hackett]))
//						case 3:
//							track.assertAuthors(artists: Artist.assertMany([Rutherford, Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford]))
//						case 4:
//							track.assertAuthors(artists: Artist.assertMany([Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//						case 5:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Collins]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//						case 6:
//							track.assertAuthors(artists: Artist.assertMany([Rutherford, Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford]))
//						case 7:
//							track.assertAuthors(artists: Artist.assertMany([Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//						case 8:
//							track.assertAuthors(artists: Artist.assertMany([Collins, Hackett, Rutherford, Banks]))
//						default:
//							break
//					}
//					track.log()
//					PersistenceController.shared.saveData()
//					print("track now has \(track.authors?.count ?? 0) author(s)")
//				}
//			}
//
//			Album.assert("Wind And Wuthering", artist: genesis) { album, isNew in
//				album.releaseYear = 1976
//				addTracks(album: album, titles: [
//					"Eleventh Earl of Mar",
//					"One for the Vine",
//					"Your Own Special Way",
//					"Wot Gorilla",
//					"All in a Mouse's Night",
//					"Blood on the Rooftops",
//					"Unquiet Slumber for the Sleepers...",
//					"...In That Quiet Earth",
//					"Afterglow"
//				]) { track in
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					switch track.trackNo {
//						case 1:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Hackett, Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford]))
//						case 2:
//							track.assertAuthors(artists: Artist.assertMany([Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//						case 3:
//							track.assertAuthors(artists: Artist.assertMany([Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford]))
//						case 4:
//							track.assertAuthors(artists: Artist.assertMany([Collins, Banks]))
//						case 5:
//							track.assertAuthors(artists: Artist.assertMany([Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//						case 6:
//							track.assertAuthors(artists: Artist.assertMany([Hackett, Collins]))
//							track.assertLyricists(lyricists: Artist.assertMany([Hackett, Collins]))
//						case 7:
//							track.assertAuthors(artists: Artist.assertMany([Hackett, Rutherford]))
//						case 8:
//							track.assertAuthors(artists: Artist.assertMany([Hackett, Rutherford, Banks, Collins]))
//						case 9:
//							track.assertAuthors(artists: Artist.assertMany([Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//						default:
//							break
//					}
//					track.log()
//					PersistenceController.shared.saveData()
//					print("track now has \(track.authors?.count ?? 0) author(s)")
//				}
//			}
//
//			Album.assert("...And Then There Were Three", artist: genesis) { album, isNew in
//				album.releaseYear = 1978
//				addTracks(album: album, titles: [
//					"Down and Out",
//					"Undertow",
//					"Ballad of Big",
//					"Snowbound",
//					"Burning Rope",
//					"Deep in the Motherlode",
//					"Many Too Many",
//					"Scenes from a Night's Dream",
//					"Say It's Alright Joe",
//					"The Lady Lies",
//					"Follow You, Follow Me"
//				]) { track in
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					switch track.trackNo {
//						case 1:
//							track.assertAuthors(artists: Artist.assertMany([Collins, Banks, Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Collins]))
//						case 2:
//							track.assertAuthors(artists: Artist.assertMany([Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//						case 3:
//							track.assertAuthors(artists: Artist.assertMany([Collins, Banks, Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Collins]))
//						case 4:
//							track.assertAuthors(artists: Artist.assertMany([Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford]))
//						case 5:
//							track.assertAuthors(artists: Artist.assertMany([Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//						case 6:
//							track.assertAuthors(artists: Artist.assertMany([Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford]))
//						case 7:
//							track.assertAuthors(artists: Artist.assertMany([Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//						case 8:
//							track.assertAuthors(artists: Artist.assertMany([Collins, Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Collins]))
//						case 9:
//							track.assertAuthors(artists: Artist.assertMany([Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford]))
//						case 10:
//							track.assertAuthors(artists: Artist.assertMany([Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//						case 11:
//							track.assertAuthors(artists: Artist.assertMany([Rutherford, Banks, Collins]))
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford]))
//						default:
//							break
//					}
//					track.log()
//					PersistenceController.shared.saveData()
//					print("track now has \(track.authors?.count ?? 0) author(s)")
//				}
//			}
//
//			Album.assert("Duke", artist: genesis) { album, isNew in
//				album.releaseYear = 1980
//				addTracks(album: album, titles: [
//					"Behind the Lines",
//					"Duchess",
//					"Guide Vocal",
//					"Man of Our Times",
//					"Misunderstanding",
//					"Heathaze",
//					"Turn It On Again",
//					"Alone Tonight",
//					"Cul-de-sac",
//					"Please Don't Ask",
//					"Duke's Travels",
//					"Duke's End"
//				]) { track in
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					switch track.trackNo {
//						case 1:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Collins, Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford]))
//						case 2:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Collins, Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//						case 3:
//							track.assertAuthors(artists: Artist.assertMany([Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//						case 4:
//							track.assertAuthors(artists: Artist.assertMany([Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford]))
//						case 5:
//							track.assertAuthors(artists: Artist.assertMany([Collins]))
//							track.assertLyricists(lyricists: Artist.assertMany([Collins]))
//						case 6:
//							track.assertAuthors(artists: Artist.assertMany([Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//						case 7:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Collins, Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford]))
//						case 8:
//							track.assertAuthors(artists: Artist.assertMany([Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford]))
//						case 9:
//							track.assertAuthors(artists: Artist.assertMany([Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//						case 10:
//							track.assertAuthors(artists: Artist.assertMany([Collins]))
//							track.assertLyricists(lyricists: Artist.assertMany([Collins]))
//						case 11:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Collins, Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//						case 12:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Collins, Rutherford]))
//						default:
//							break
//					}
//					track.log()
//					PersistenceController.shared.saveData()
//					print("track now has \(track.authors?.count ?? 0) author(s)")
//				}
//			}
//
//			Album.assert("Abacab", artist: genesis) { album, isNew in
//				album.releaseYear = 1981
//				addTracks(album: album, titles: [
//					"Abacab",
//					"No Reply at All",
//					"Me and Sarah Jane",
//					"Keep It Dark",
//					"Dodo/Lurker",
//					"Whodunnit?",
//					"Man on the Corner",
//					"Like It or Not",
//					"Another Record"
//				]) { track in
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					switch track.trackNo {
//						case 1:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Collins, Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford]))
//						case 2:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Collins, Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Collins]))
//						case 3:
//							track.assertAuthors(artists: Artist.assertMany([Banks]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//						case 4:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Collins, Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//						case 5:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Collins, Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//						case 6:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Collins, Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Collins]))
//						case 7:
//							track.assertAuthors(artists: Artist.assertMany([Collins]))
//							track.assertLyricists(lyricists: Artist.assertMany([Collins]))
//						case 8:
//							track.assertAuthors(artists: Artist.assertMany([Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford]))
//						case 9:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Collins, Rutherford]))
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford]))
//						default:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Collins, Rutherford]))
//					}
//					track.log()
//					PersistenceController.shared.saveData()
//					print("track now has \(track.authors?.count ?? 0) author(s)")
//				}
//			}
//
//			Album.assert("Genesis", artist: genesis) { album, isNew in
//				album.releaseYear = 1983
//				addTracks(album: album, titles: [
//					"Mama",
//					"That's All",
//					"Home By The Sea",
//					"Second Home By The Sea",
//					"Illegal Alien",
//					"Taking It All Too Hard",
//					"Just a Job to Do",
//					"Silver Rainbow",
//					"It's Gonna Get Better"
//				]) { track in
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					track.assertAuthors(artists: Artist.assertMany([Banks, Collins, Rutherford]))
//					switch track.trackNo {
//						case 1,2:
//							track.assertLyricists(lyricists: Artist.assertMany([Collins]))
//						case 3,4,8:
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//						default:
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford]))
//
//					}
//					track.log()
//					PersistenceController.shared.saveData()
//					print("track now has \(track.authors?.count ?? 0) author(s)")
//				}
//			}
//
//			Album.assert("Invisible Touch", artist: genesis) { album, isNew in
//				album.releaseYear = 1986
//				addTracks(album: album, titles: [
//					"Invisible Touch",
//					"Tonight Tonight Tonight",
//					"Land of Confusion",
//					"In Too Deep",
//					"Anything She Does",
//					"Domino",
//					"Throwing It All Away",
//					"The Brazilian"
//				]) { track in
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					track.assertAuthors(artists: Artist.assertMany([Banks, Collins, Rutherford]))
//					switch track.trackNo {
//						case 1, 2, 4:
//							track.assertLyricists(lyricists: Artist.assertMany([Collins]))
//						case 3, 7:
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford]))
//						default:
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//
//					}
//					track.log()
//					PersistenceController.shared.saveData()
//					print("track now has \(track.authors?.count ?? 0) author(s)")
//				}
//			}
//
//			Album.assert("We Can't Dance", artist: genesis) { album, isNew in
//				album.releaseYear = 1991
//				addTracks(album: album, titles: [
//					"No Son of Mine",
//					"Jesus He Knows Me",
//					"Driving the Last Spike",
//					"I Can't Dance",
//					"Never a Time",
//					"Dreaming While You Sleep",
//					"Tell Me Why?",
//					"Living Forever",
//					"Hold on My Heart",
//					"Way of the World",
//					"Since I Lost You",
//					"Fading Lights"
//				]) { track in
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					track.assertAuthors(artists: Artist.assertMany([Banks, Collins, Rutherford]))
//					switch track.trackNo {
//						case 1, 2, 3, 4, 7, 9, 11:
//							track.assertLyricists(lyricists: Artist.assertMany([Collins]))
//						case 5, 6, 10:
//							track.assertLyricists(lyricists: Artist.assertMany([Rutherford]))
//						default:
//							track.assertLyricists(lyricists: Artist.assertMany([Banks]))
//
//					}
//					track.log()
//					PersistenceController.shared.saveData()
//					print("track now has \(track.authors?.count ?? 0) author(s)")
//				}
//			}
//
//			Album.assert("Calling All Stations", artist: genesis) { album, isNew in
//				album.releaseYear = 1997
//				addTracks(album: album, titles: [
//					"Calling All Stations",
//					"Congo",
//					"Shipwrecked",
//					"Alien Afternoon",
//					"Not About Us",
//					"If That's What You Need",
//					"The Dividing Line",
//					"Uncertain Weather",
//					"Small Talk",
//					"There Must Be Some Other Way",
//					"One Man's Fool"
//				]) { track in
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					track.assertLyricists(lyricists: Artist.assertMany([Banks, Rutherford]))
//					switch track.trackNo {
//						case 5, 9, 10:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Rutherford, "Ray Wilson"]))
//						default:
//							track.assertAuthors(artists: Artist.assertMany([Banks, Rutherford]))
//					}
//					track.log()
//					PersistenceController.shared.saveData()
//					print("track now has \(track.authors?.count ?? 0) author(s)")
//				}
//			}
//
//			PersistenceController.shared.saveData()
//			print(genesis.tracksOrdered())
//		}
//		Artist.assert("Crowded House") { artist, isNew in
//
//			let Finn = "Neil Finn"
//			let Seymour = "Nick Seymour"
//			let Froom = "Mitchell Froom"
//			let Rayner = "Eddie Rayner"
//			let Hester = "Paul Hester"
//			let Hart = "Mark Hart"
//			let FinnT = "Tim Finn"
//			let FinnE = "Elroy Finn"
//			let FinnL = "Liam Finn"
//			let Wehi = "Ngapo 'Bub' Wehi"
//
//			Album.assert("Crowded House", artist: artist) { album, isNew in
//				album.releaseYear = 1986
//				addTracks(album: album, titles: [
//					"Mean to Me",
//					"World Where You Live",
//					"Now We're Getting Somewhere",
//					"Don't Dream It's Over",
//					"Love You 'Til the Day I Die",
//					"Something So Strong",
//					"Hold in the River",
//					"Can't Carry On",
//					"I Walk Away",
//					"Tombstone",
//					"That's What I Call Love"
//				]) { track in
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					switch track.trackNo {
//						case 6:
//							track.assertAuthors(artists: Artist.assertMany([Finn, Froom]))
//							track.assertLyricists(lyricists: Artist.assertMany([Finn, Froom]))
//						case 7:
//							track.assertAuthors(artists: Artist.assertMany([Finn, Rayner]))
//							track.assertLyricists(lyricists: Artist.assertMany([Finn, Rayner]))
//						case 11:
//							track.assertAuthors(artists: Artist.assertMany([Finn, Hester]))
//							track.assertLyricists(lyricists: Artist.assertMany([Finn, Hester]))
//						default:
//							track.assertAuthors(artists: Artist.assertMany([Finn]))
//							track.assertLyricists(lyricists: Artist.assertMany([Finn]))
//					}
//				}
//			}
//			Album.assert("Temple of Low Men", artist: artist) { album, isNew in
//				album.releaseYear = 1988
//				addTracks(album: album, titles: [
//					"I Feel Possessed",
//					"Kill Eye",
//					"Into Temptation",
//					"Mansion in the Slums",
//					"When You Come",
//					"Never Be the Same",
//					"Love This Life",
//					"Sister Madly",
//					"In the Lowlands",
//					"Better Be Home Soon"
//				]) { track in
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					switch track.trackNo {
//						default:
//							track.assertAuthors(artists: Artist.assertMany([Finn]))
//							track.assertLyricists(lyricists: Artist.assertMany([Finn]))
//					}
//				}
//			}
//			Album.assert("Woodface", artist: artist) { album, isNew in
//				album.releaseYear = 1991
//				addTracks(album: album, titles: [
//					"Chocolate Cake",
//					"It's Only Natural",
//					"Fall at Your Feet",
//					"Tall Trees",
//					"Weather with You",
//					"Whispers and Moans",
//					"Four Seasons in One Day",
//					"There Goes God",
//					"Fame Is",
//					"All I Ask",
//					"As Sure as I Am",
//					"Italian Plastic",
//					"She Goes On",
//					"How Will You Go"
//				]) { track in
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					switch track.trackNo {
//						case 3,6,9,11,13:
//							track.assertAuthors(artists: Artist.assertMany([Finn]))
//							track.assertLyricists(lyricists: Artist.assertMany([Finn]))
//						case 12:
//							track.assertAuthors(artists: Artist.assertMany([Hester]))
//							track.assertLyricists(lyricists: Artist.assertMany([Hester]))
//						case 14:
//							track.assertAuthors(artists: Artist.assertMany([Hester, Finn, Seymour]))
//							track.assertLyricists(lyricists: Artist.assertMany([Hester, Finn, Seymour]))
//						default:
//							track.assertAuthors(artists: Artist.assertMany([Finn, FinnT]))
//							track.assertLyricists(lyricists: Artist.assertMany([Finn, FinnT]))
//					}
//				}
//			}
//			Album.assert("Together Alone", artist: artist) { album, isNew in
//				album.releaseYear = 1993
//				addTracks(album: album, titles: [
//					"Kare Kare",
//					"In My Command",
//					"Nails in My Feet",
//					"Black and White Boy",
//					"Fingers of Love",
//					"Pineapple Head",
//					"Locked Out",
//					"Private Universe",
//					"Walking on the Spot",
//					"Distant Sun",
//					"Catherine Wheels",
//					"Skin Feeling",
//					"Together Alone"
//				]) { track in
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					switch track.trackNo {
//						case 1:
//							track.assertAuthors(artists: Artist.assertMany([Finn, Hart, Seymour, Hester]))
//							track.assertLyricists(lyricists: Artist.assertMany([Finn, Hart, Seymour, Hester]))
//						case 11:
//							track.assertAuthors(artists: Artist.assertMany([Finn, FinnT, Seymour]))
//							track.assertLyricists(lyricists: Artist.assertMany([Finn, FinnT, Seymour]))
//						case 12:
//							track.assertAuthors(artists: Artist.assertMany([Hester]))
//							track.assertLyricists(lyricists: Artist.assertMany([Hester]))
//						case 13:
//							track.assertAuthors(artists: Artist.assertMany([Finn, Hart, Wehi]))
//							track.assertLyricists(lyricists: Artist.assertMany([Finn, Hart, Wehi]))
//
//						default:
//							track.assertAuthors(artists: Artist.assertMany([Finn]))
//							track.assertLyricists(lyricists: Artist.assertMany([Finn]))
//					}
//				}
//			}
//			Album.assert("Time on Earth", artist: artist) { album, isNew in
//				album.releaseYear = 2007
//				addTracks(album: album, titles: [
//					"Nobody Wants To",
//					"Don't Stop Now",
//					"She Called Up",
//					"Say That Again",
//					"Pour le monde",
//					"Even a Child",
//					"Heaven That I'm Making",
//					"A Sigh",
//					"Silent House",
//					"English Trees",
//					"Walked Her Way Down",
//					"Transit Lounge",
//					"You Are the One to Make Me Cry",
//					"People Are Like Suns"
//				]) { track in
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					switch track.trackNo {
//						case 6:
//							track.assertAuthors(artists: Artist.assertMany([Finn, "Johnny Marr"]))
//							track.assertLyricists(lyricists: Artist.assertMany([Finn, "Johnny Marr"]))
//						case 9:
//							track.assertAuthors(artists: Artist.assertMany([Finn, "Martie Maguire", "Natalie Maines", "Emily Robison"]))
//							track.assertLyricists(lyricists: Artist.assertMany([Finn, "Martie Maguire", "Natalie Maines", "Emily Robison"]))
//						default:
//							track.assertAuthors(artists: Artist.assertMany([Finn]))
//							track.assertLyricists(lyricists: Artist.assertMany([Finn]))
//					}
//				}
//			}
//			Album.assert("Intriguer", artist: artist) { album, isNew in
//				album.releaseYear = 2010
//				addTracks(album: album, titles: [
//					"Saturday Sun",
//					"Archer's Arrows",
//					"Amsterdam",
//					"Either Side of the World",
//					"Falling Dove",
//					"Isolation",
//					"Twice if You're Lucky",
//					"Inside Out",
//					"Even If",
//					"Elephants"
//				]) { track in
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					switch track.trackNo {
//						case 6:
//							track.assertAuthors(artists: Artist.assertMany([Finn, Hart, Seymour, "Matt Sherrod"]))
//							track.assertLyricists(lyricists: Artist.assertMany([Finn, Hart, Seymour, "Matt Sherrod"]))
//						default:
//							track.assertAuthors(artists: Artist.assertMany([Finn]))
//							track.assertLyricists(lyricists: Artist.assertMany([Finn]))
//					}
//				}
//			}
//			Album.assert("Dreamers are Waiting", artist: artist) { album, isNew in
//				album.releaseYear = 2021
//				addTracks(album: album, titles: [
//					"Bad Times Good",
//					"Playing with Fire",
//					"To the Island",
//					"Sweet Tooth",
//					"Whatever You Want",
//					"Show Me the Way",
//					"Goodnight Everyone",
//					"Too Good for This World",
//					"Start of Something",
//					"Real Life Woman",
//					"Love Isn't Hard at All",
//					"Deeper Down"
//				]) { track in
//					track.removeAllAuthors()
//					track.removeAllLyricists()
//					switch track.trackNo {
//						case 1:
//							track.assertAuthors(artists: Artist.assertMany([Finn, FinnL, FinnE, Seymour]))
//							track.assertLyricists(lyricists: Artist.assertMany([Finn, FinnL, FinnE, Seymour]))
//						case 2:
//							track.assertAuthors(artists: Artist.assertMany([Finn, FinnL, FinnE, Seymour, Froom]))
//							track.assertLyricists(lyricists: Artist.assertMany([Finn, FinnL, FinnE, Seymour, Froom]))
//						case 7:
//							track.assertAuthors(artists: Artist.assertMany([FinnL]))
//							track.assertLyricists(lyricists: Artist.assertMany([FinnL]))
//						case 8:
//							track.assertAuthors(artists: Artist.assertMany([Finn, FinnT]))
//							track.assertLyricists(lyricists: Artist.assertMany([Finn, FinnT]))
//						case 9:
//							track.assertAuthors(artists: Artist.assertMany([FinnL, Finn]))
//							track.assertLyricists(lyricists: Artist.assertMany([FinnL, Finn]))
//						case 11:
//							track.assertAuthors(artists: Artist.assertMany([FinnE, Finn]))
//							track.assertLyricists(lyricists: Artist.assertMany([FinnE, Finn]))
//						default:
//							track.assertAuthors(artists: Artist.assertMany([Finn]))
//							track.assertLyricists(lyricists: Artist.assertMany([Finn]))
//					}
//				}
//			}
//		}
		
		PersistenceController.shared.saveData()
	}

    init(inMemory: Bool = false) {
		Log.devMode = true
        container = NSPersistentContainer(name: "MyMusic")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
