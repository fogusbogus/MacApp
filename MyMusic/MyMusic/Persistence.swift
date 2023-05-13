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
		
	func addTracks(album: Album, titles: [String], completion: ((Track) -> Void)? = nil) {
		var trackNo = (album.tracksOrdered().map({$0.trackNo}).max() ?? 0)+1
		titles.forEach { track in
			Track.assert(track, album: album) { trk, isNew in
				if isNew {
					trk.trackNo = Int32(trackNo)
					trackNo += 1
				}
				if let complete = completion {
					complete(trk)
				}
			}
		}
	}
	
	func seedData() {
		
//		let all = Artist.getAll()
//		all.forEach({PersistenceController.shared.container.viewContext.delete($0)})
//		try? PersistenceController.shared.container.viewContext.save()
		
		Artist.assert("Genesis") { genesis, isNew in
			Album.assert("From Genesis To Revelation", artist: genesis) { fgtr, isNew in
				fgtr.releaseYear = 1969
				addTracks(album: fgtr, titles: [
					"Where The Sour Turns to Sweet",
					"In the Beginning",
					"Fireside Song",
					"The Serpent",
					"Am I Very Wrong?",
					"Into the Wilderness",
					"The Conqueror",
					"In Hiding",
					"One Day",
					"Window",
					"In Limbo",
					"The Silent Sun",
					"A Place to Call My Own"
				]) { track in
					track.assertAuthors(artists: Artist.assertMany(["Tony Banks", "Mike Rutherford", "Peter Gabriel", "Anthony Phillips"]))
				}
			}
			
			Album.assert("Trespass", artist: genesis) { album, isNew in
				album.releaseYear = 1970
				addTracks(album: album, titles: [
					"Looking for Someone",
					"White Mountain",
					"Visions of Angels",
					"Stagnation",
					"Dusk",
					"The Knife"
				]) { track in
					track.assertAuthors(artists: Artist.assertMany(["Tony Banks", "Mike Rutherford", "Peter Gabriel", "Anthony Phillips"]))
				}
			}
			
			Album.assert("Nursery Cryme", artist: genesis) { album, isNew in
				album.releaseYear = 1971
				addTracks(album: album, titles: [
					"The Musical Box",
					"For Absent Friends",
					"The Return of the Giant Hogweed",
					"Seven Stones",
					"Harold the Barrel",
					"Harlequin",
					"The Fountain of Salmacis"
				]) { track in
					print(track.trackNo)
					switch track.trackNo {
						case 1:
							track.assertAuthors(artists: Artist.assertMany(["Tony Banks", "Mike Rutherford", "Peter Gabriel", "Steve Hackett", "Anthony Phillips", "Phil Collins"]))
						case 2:
							track.assertAuthors(artists: Artist.assertMany(["Steve Hackett", "Phil Collins"]))
						case 3:
							track.assertAuthors(artists: Artist.assertMany(["Tony Banks", "Mike Rutherford", "Peter Gabriel", "Steve Hackett"]))
						case 4:
							track.assertAuthors(artists: Artist.assertMany(["Tony Banks",  "Steve Hackett"]))
						case 5:
							track.assertAuthors(artists: Artist.assertMany(["Peter Gabriel", "Phil Collins"]))
						case 6:
							track.assertAuthors(artists: Artist.assertMany([ "Mike Rutherford", "Anthony Phillips"]))
						case 7:
							track.assertAuthors(artists: Artist.assertMany(["Tony Banks", "Mike Rutherford", "Peter Gabriel", "Steve Hackett"]))

						default:
							track.assertAuthors(artists: Artist.assertMany(["Tony Banks", "Mike Rutherford", "Peter Gabriel", "Steve Hackett", "Phil Collins"]))
					}
					try? track.managedObjectContext?.save()
					print("track now has \(track.authors?.count ?? 0) author(s)")
				}
			}
			
			Album.assert("Foxtrot", artist: genesis) { album, isNew in
				album.releaseYear = 1972
				addTracks(album: album, titles: [
					"Watcher of the Skies",
					"Time Table",
					"Get 'Em Out by Friday",
					"Can-Utility and the Coastliners",
					"Horizons",
					"Supper's Ready"
				])
			}
			
			Album.assert("Selling England By The Pound", artist: genesis) { album, isNew in
				album.releaseYear = 1973
				addTracks(album: album, titles: [
					"Dancing with the Moonlit Knight",
					"I Know What I Like (In Your Wardrobe)",
					"Firth of Fifth",
					"More Fool Me",
					"The Battle of Epping Forest",
					"After the Ordeal",
					"The Cinema Show",
					"Aisle of Plenty"
				])
			}
			
			Album.assert("The Lamb Lies Down On Broadway", artist: genesis) { album, isNew in
				album.releaseYear = 1974
				addTracks(album: album, titles: [
					"The Lamb Lies Down on Broadway",
					"Fly on a Windshield",
					"Broadway Melody of 1974",
					"Cuckoo Cocoon",
					"In the Cage",
					"The Grand Parade of Lifeless Packaging",
					"Back in N.Y.C.",
					"Hairless Heart",
					"Counting Out Time",
					"The Carpet Crawlers",
					"The Chamber of 32 Doors",
					"Lilywhite Lilith",
					"The Waiting Room",
					"Anyway",
					"Here Comes the Supernatural Anaesthetist",
					"The Lamia",
					"Silent Sorrow in Empty Boats",
					"The Colony of Slippermen (The Arrival/A Visit to the Doktor/The Raven)",
					"Ravine",
					"The Light Dies Down on Broadway",
					"Riding the Scree",
					"In the Rapids",
					"it"
				])
			}
			
			Album.assert("A Trick Of The Tail", artist: genesis) { album, isNew in
				album.releaseYear = 1976
				addTracks(album: album, titles: [
					"Dance on a Volcano",
					"Entangled",
					"Squonk",
					"Mad Man Moon",
					"Robbery, Assault & Battery",
					"Ripples",
					"A Trick of the Tail",
					"Los Endos"
				])
			}
			
			Album.assert("Wind And Wuthering", artist: genesis) { album, isNew in
				album.releaseYear = 1976
				addTracks(album: album, titles: [
					"Eleventh Earl of Mar",
					"One for the Vine",
					"Your Own Special Way",
					"Wot Gorilla",
					"All in a Mouse's Night",
					"Blood on the Rooftops",
					"Unquiet Slumber for the Sleepers...",
					"...In That Quiet Earth",
					"Afterglow"
				])
			}
			
			Album.assert("...And Then There Were Three", artist: genesis) { album, isNew in
				album.releaseYear = 1978
				addTracks(album: album, titles: [
					"Down and Out",
					"Undertow",
					"Ballad of Big",
					"Snowbound",
					"Burning Rope",
					"Deep in the Motherlode",
					"Many Too Many",
					"Scenes from a Night's Dream",
					"Say It's Alright Joe",
					"The Lady Lies",
					"Follow You, Follow Me"
				])
			}
			
			Album.assert("Duke", artist: genesis) { album, isNew in
				album.releaseYear = 1980
				addTracks(album: album, titles: [
					"Behind the Lines",
					"Duchess",
					"Guide Vocal",
					"Man of Our Times",
					"Misunderstanding",
					"Heathaze",
					"Turn It On Again",
					"Alone Tonight",
					"Cul-de-sac",
					"Please Don't Ask",
					"Duke's Travels",
					"Duke's End"
				])
			}
			
			Album.assert("Abacab", artist: genesis) { album, isNew in
				album.releaseYear = 1981
				addTracks(album: album, titles: [
					"Abacab",
					"No Reply at All",
					"Me and Sarah Jane",
					"Keep It Dark",
					"Dodo/Lurker",
					"Whodunnit?",
					"Man on the Corner",
					"Like It or Not",
					"Another Record"
				])
			}
			
			Album.assert("Genesis", artist: genesis) { album, isNew in
				album.releaseYear = 1983
				addTracks(album: album, titles: [
					"Mama",
					"That's All",
					"Home By The Sea",
					"Second Home By The Sea",
					"Illegal Alien",
					"Taking It All Too Hard",
					"Just a Job to Do",
					"Silver Rainbow",
					"It's Gonna Get Better"
				])
			}
			
			Album.assert("Invisible Touch", artist: genesis) { album, isNew in
				album.releaseYear = 1986
				addTracks(album: album, titles: [
					"Invisible Touch",
					"Tonight Tonight Tonight",
					"Land of Confusion",
					"In Too Deep",
					"Anything She Does",
					"Domino",
					"Throwing It All Away",
					"The Brazilian"
				])
			}
			
			Album.assert("We Can't Dance", artist: genesis) { album, isNew in
				album.releaseYear = 1991
				addTracks(album: album, titles: [
					"No Son of Mine",
					"Jesus He Knows Me",
					"Driving the Last Spike",
					"I Can't Dance",
					"Never a Time",
					"Dreaming While You Sleep",
					"Tell Me Why?",
					"Living Forever",
					"Hold on My Heart",
					"Way of the World",
					"Since I Lost You",
					"Fading Lights"
				])
			}
			
			Album.assert("Calling All Stations", artist: genesis) { album, isNew in
				album.releaseYear = 1997
				addTracks(album: album, titles: [
					"Calling All Stations",
					"Congo",
					"Shipwrecked",
					"Alien Afternoon",
					"Not About Us",
					"If That's What You Need",
					"The Dividing Line",
					"Uncertain Weather",
					"Small Talk",
					"There Must Be Some Other Way",
					"One Man's Fool"
				])
			}

			do {
				try PersistenceController.shared.container.viewContext.save()
			}
			catch {
				print(error)
			}
			print(genesis.tracksOrdered())
		}
		Artist.assert("Crowded House") { artist, isNew in
			Album.assert("Crowded House", artist: artist) { album, isNew in
				album.releaseYear = 1986
				addTracks(album: album, titles: [
					"Mean to Me",
					"World Where You Live",
					"Now We're Getting Somewhere",
					"Don't Dream It's Over",
					"Love You 'Til the Day I Die",
					"Something So Strong",
					"Hold in the River",
					"Can't Carry On",
					"I Walk Away",
					"Tombstone",
					"That's What I Call Love"
				])
			}
			Album.assert("Temple of Low Men", artist: artist) { album, isNew in
				album.releaseYear = 1988
				addTracks(album: album, titles: [
					"I Feel Possessed",
					"Kill Eye",
					"Into Temptation",
					"Mansion in the Slums",
					"When You Come",
					"Never Be the Same",
					"Love This Life",
					"Sister Madly",
					"In the Lowlands",
					"Better Be Home Soon"
				])
			}
			Album.assert("Woodface", artist: artist) { album, isNew in
				album.releaseYear = 1991
				addTracks(album: album, titles: [
					"Chocolate Cake",
					"It's Only Natural",
					"Fall at Your Feet",
					"Tall Trees",
					"Weather with You",
					"Whispers and Moans",
					"Four Seasons in One Day",
					"There Goes God",
					"Fame Is",
					"All I Ask",
					"As Sure as I Am",
					"Italian Plastic",
					"She Goes On",
					"How Will You Go"
				])
			}
			Album.assert("Together Alone", artist: artist) { album, isNew in
				album.releaseYear = 1993
				addTracks(album: album, titles: [
					"Kare Kare",
					"In My Command",
					"Nails in My Feet",
					"Black and White Boy",
					"Fingers of Love",
					"Pineapple Head",
					"Locked Out",
					"Private Universe",
					"Walking on the Spot",
					"Distant Sun",
					"Catherine Wheels",
					"Skin Feeling",
					"Together Alone"
				])
			}
			Album.assert("Time on Earth", artist: artist) { album, isNew in
				album.releaseYear = 2007
				addTracks(album: album, titles: [
					"Nobody Wants To",
					"Don't Stop Now",
					"She Called Up",
					"Say That Again",
					"Pour le monde",
					"Even a Child",
					"Heaven That I'm Making",
					"A Sigh",
					"Silent House",
					"English Trees",
					"Walked Her Way Down",
					"Transit Lounge",
					"You Are the One to Make Me Cry",
					"People Are Like Suns"
				])
			}
			Album.assert("Intriguer", artist: artist) { album, isNew in
				album.releaseYear = 2010
				addTracks(album: album, titles: [
					"Saturday Sun",
					"Archer's Arrows",
					"Amsterdam",
					"Either Side of the World",
					"Falling Dove",
					"Isolation",
					"Twice if You're Lucky",
					"Inside Out",
					"Even If",
					"Elephants"
				])
			}
			Album.assert("Dreamers are Waiting", artist: artist) { album, isNew in
				album.releaseYear = 2021
				addTracks(album: album, titles: [
					"Bad Times Good",
					"Playing with Fire",
					"To the Island",
					"Sweet Tooth",
					"Whatever You Want",
					"Show Me the Way",
					"Goodnight Everyone",
					"Too Good for This World",
					"Start of Something",
					"Real Life Woman",
					"Love Isn't Hard at All",
					"Deeper Down"
				])
			}
		}
		
		do {
			try PersistenceController.shared.container.viewContext.save()
		}
		catch {
			print(error)
		}
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
