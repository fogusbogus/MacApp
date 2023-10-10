//
//  GuitarTestApp.swift
//  GuitarTest
//
//  Created by Matt Hogg on 09/10/2023.
//

import SwiftUI
import SwiftData
import midiGuitarGenerator

@main
struct GuitarTestApp: App {
	
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
				.onAppear(perform: {
					generate()
				})
        }
        .modelContainer(sharedModelContainer)
    }
	
	func generate() {
		var gtr = Guitar()
		
		livingForever(gtr)
		
//		var chd_D = Chord { chd in
//			chd.frets = [-1, -1, 0, 2, 3, 2]
//		}
//		var chd_Dsus2 = Chord { chd in
//			chd.frets = [-1, -1, 0, 2, 3, 0]
//		}
//		var chd_Dsus4 = Chord { chd in
//			chd.frets = [-1, -1, 0, 2, 3, 3]
//		}
//		gtr.addEvent(position: 0, Emulation(is12String: true))
//		gtr.addEvent(position: 0, TempoEvent(148.0))
//		gtr.autoStrum(chord: chd_D, timecode: "1:1:0", velocity: 127, interval: 4, direction: .down)
//		gtr.autoStrum(chord: chd_D, timecode: "1:1:32", velocity: 127, interval: 4, direction: .up)
//		gtr.autoStrum(chord: chd_D, timecode: "1:1:64", velocity: 127, interval: 4, direction: .down)
//		gtr.autoStrum(chord: chd_D, timecode: "1:2:0", velocity: 127, interval: 4, direction: .up)
//		gtr.autoStrum(chord: chd_Dsus2, timecode: "1:2:32", velocity: 127, interval: 4, direction: .down)
//		gtr.autoStrum(chord: chd_Dsus2, timecode: "1:2:64", velocity: 127, interval: 4, direction: .up)
//		gtr.autoStrum(chord: chd_Dsus4, timecode: "1:3:0", velocity: 127, interval: 4, direction: .down)
//		gtr.autoStrum(chord: chd_Dsus4, timecode: "1:3:32", velocity: 127, interval: 4, direction: .up)
//		gtr.autoStrum(chord: chd_Dsus4, timecode: "1:3:64", velocity: 127, interval: 4, direction: .down)
//		gtr.autoStrum(chord: chd_Dsus4, timecode: "1:4:0", velocity: 127, interval: 4, direction: .up)
//		gtr.autoStrum(chord: chd_Dsus2, timecode: "1:4:32", velocity: 127, interval: 4, direction: .down)
//		gtr.autoStrum(chord: chd_Dsus2, timecode: "1:4:64", velocity: 127, interval: 4, direction: .up)
//		gtr.autoStrum(chord: chd_D, timecode: "2:1:0", velocity: 127, interval: 4, direction: .down)
//		gtr.autoStrum(chord: chd_D, timecode: "2:1:32", velocity: 127, interval: 4, direction: .up)
//		gtr.autoStrum(chord: chd_D, timecode: "2:1:64", velocity: 127, interval: 4, direction: .down)
//		gtr.autoStrum(chord: chd_D, timecode: "2:2:0", velocity: 127, interval: 4, direction: .up)
//		gtr.autoStrum(chord: chd_D, timecode: "2:2:32", velocity: 127, interval: 4, direction: .down)
//		gtr.autoStrum(chord: chd_D, timecode: "2:2:64", velocity: 127, interval: 4, direction: .up)
//		gtr.autoStrum(chord: chd_D, timecode: "2:3:0", velocity: 127, interval: 4, direction: .down)
//		gtr.autoStrum(chord: chd_D, timecode: "2:3:32", velocity: 127, interval: 4, direction: .up)
//		gtr.autoStrum(chord: chd_D, timecode: "2:3:64", velocity: 127, interval: 4, direction: .down)
//		gtr.autoStrum(chord: chd_D, timecode: "2:4:0", velocity: 127, interval: 4, direction: .up)
//		gtr.autoStrum(chord: chd_Dsus2, timecode: "2:4:32", velocity: 127, interval: 4, direction: .down)
//		gtr.autoStrum(chord: chd_Dsus2, timecode: "2:4:64", velocity: 127, interval: 4, direction: .up)

//		gtr.strum(chord: chd, position: 384, mask: "X-----".getMask(), velocities: [0,127,122,117,115,113], interval: 4, direction: .down)
//		gtr.strum(chord: chd, position: 384*3, mask: "X-----".getMask(), velocities: [0,113,115,117,122,127], interval: 4, direction: .up)
//		gtr.strum(chord: chd, position: 1500, mask: "X-----".getMask(), velocities: [0,0,0,0,0,0], interval: 4, direction: .down)
		
		let data = gtr.generateMIDIData()
		do {
			let url = FileManager.default.urls(for: .documentDirectory,
											   in: .userDomainMask)[0].appendingPathComponent("GuitarTest.mid")
			
			try data.write(to: url)
		}
		catch {
			print(error)
		}
	}
	
	func livingForever(_ gtr: Guitar) {
		/*
		 Intro	Ab			-1	6	6	8	-1	-1
		 Eb			-1	6	8	8	-1	-1
		 Bb			6	8	8	-1	-1	-1
		 Gb			2	4	4	-1	-1	-1
		 */

		let intro_Ab = Chord { chd in
			chd.collection = "Intro"
			chd.name = "Ab"
			chd.frets = [-1,6,6,8,-1,-1]
		}

		let intro_Eb = Chord { chd in
			chd.collection = "Intro"
			chd.name = "Eb"
			chd.frets = [-1,6,8,8,-1,-1]
		}

		let intro_Bb = Chord { chd in
			chd.collection = "Intro"
			chd.name = "Bb"
			chd.frets = [6,8,8,-1,-1,-1]
		}
		
		let intro_Gb = Chord { chd in
			chd.collection = "Intro"
			chd.name = "Gb"
			chd.frets = [2,4,4,-1,-1,-1]
		}
		
		/*
		 Verse	Bb			6	8	8	-1	-1	-1
		 */

		let verse_Bb = Chord { chd in
			chd.collection = "Verse"
			chd.name = "Bb"
			chd.frets = [6,8,8,-1,-1,-1]
		}

		/*
		 Chorus	Ab5			4	6	6
		 Bb5			6	8	8
		 G5			3	5	5
		 Eb5				6	8	8
		 */
		
		let chorus_Ab5 = Chord { chd in
			chd.collection = "Chorus"
			chd.name = "Ab5"
			chd.frets = [4,6,6,-1,-1,-1]
		}
		
		let chorus_Bb5 = Chord { chd in
			chd.collection = "Chorus"
			chd.name = "Bb5"
			chd.frets = [6,8,8,-1,-1,-1]
		}
		
		let chorus_G5 = Chord { chd in
			chd.collection = "Chorus"
			chd.name = "G5"
			chd.frets = [3,5,5,-1,-1,-1]
		}
		
		let chorus_Eb5 = Chord { chd in
			chd.collection = "Chorus"
			chd.name = "Eb5"
			chd.frets = [-1,6,8,8,-1,-1]
		}
		
		/*
		 Bridge	G5			3	5	5
		 Bb/Eb				6	8	7	6	6
		 Dm7				5	7	5	6	5
		 Cm7				3	5	3	4	3
		 F					3	5	6	5
		 */
		
		let bridge_G5 = Chord { chd in
			chd.collection = "Bridge"
			chd.name = "G5"
			chd.frets = [3,5,5,-1,-1,-1]
		}
		
		let bridge_Bb_Eb = Chord { chd in
			chd.collection = "Bridge"
			chd.name = "Bb/Eb"
			chd.frets = [-1,6,8,7,6,6]
		}
		
		let bridge_Dm7 = Chord { chd in
			chd.collection = "Bridge"
			chd.name = "Dm7"
			chd.frets = [-1,5,7,5,6,5]
		}
		
		let bridge_Cm7 = Chord { chd in
			chd.collection = "Bridge"
			chd.name = "Cm7"
			chd.frets = [-1,3,5,3,4,3]
		}
		
		let bridge_F = Chord { chd in
			chd.collection = "Bridge"
			chd.name = "F"
			chd.frets = [-1,-1,3,5,6,5]
		}

		 /*
		 Instrumental	D7sus4			0	0	0	2	1	3
		 C				0	3	0	2	1	0
		 D				0	0	0	2	3	2
		 Am7				0	0	3	0	1	0
		 Bm7				0	2	5	2	3	2
		 */
		
		let inst_D7sus4 = Chord { chd in
			chd.collection = "Instrumental"
			chd.name = "D7sus4"
			chd.frets = [-1,-1,0,2,1,3]
		}
		
		let inst_C = Chord { chd in
			chd.collection = "Instrumental"
			chd.name = "C"
			chd.frets = [-1,3,0,2,1,0]
		}
		
		let inst_D = Chord { chd in
			chd.collection = "Instrumental"
			chd.name = "D"
			chd.frets = [-1,-1,0,2,3,2]
		}
		
		let inst_Am7 = Chord { chd in
			chd.collection = "Instrumental"
			chd.name = "Am7"
			chd.frets = [-1,0,3,0,1,0]
		}
		
		let inst_Bm7 = Chord { chd in
			chd.collection = "Instrumental"
			chd.name = "Bm7"
			chd.frets = [-1,2,5,2,3,2]
		}
		
		gtr.addEvent(position: 0, TempoEvent(97))
		gtr.addEvent(position: 0, TextEvent("Living Forever"))
		gtr.addEvent(position: 0, TextEvent("GENESIS"))
		gtr.addEvent(position: 0, DecayEvent(value: 5, isPercent: true))
		gtr.addEvent(position: 0, TextEvent("Guitar part (basic) by Mike Rutherford"))
		gtr.addEvent(position: 0, VariationEvent(range: -5...5, isPercent: true))
		gtr.addEvent(position: 0, StrumVariationEvent(text: "100%"))
		
		gtr.autoStrum(chord: intro_Ab, timecode: "5:1:0")
		gtr.autoStrum(chord: intro_Eb, timecode: "5:2:48")
		gtr.allNotesOff(timecode: "5:4:71")
		gtr.autoStrum(chord: intro_Bb, timecode: "5:4:72", direction: .up)
		gtr.autoStrum(chord: intro_Bb, timecode: "6:1:0")
		gtr.autoStrum(chord: intro_Bb, timecode: "6:2:48")
		gtr.allNotesOff(timecode: "6:3:0")
		
		gtr.autoStrum(chord: intro_Ab, timecode: "7:1:0")
		gtr.autoStrum(chord: intro_Eb, timecode: "7:2:48")
		gtr.autoStrum(chord: intro_Ab, timecode: "8:1:0")
		gtr.autoStrum(chord: intro_Ab, timecode: "8:2:48")
		gtr.allNotesOff(timecode: "8:3:0")
		
		gtr.autoStrum(chord: intro_Ab, timecode: "9:1:0")
		gtr.autoStrum(chord: intro_Eb, timecode: "9:2:48")
		gtr.allNotesOff(timecode: "9:4:71")
		gtr.autoStrum(chord: intro_Bb, timecode: "9:4:72", direction: .up)
		gtr.autoStrum(chord: intro_Bb, timecode: "10:1:0")
		gtr.autoStrum(chord: intro_Bb, timecode: "10:2:48")
		gtr.allNotesOff(timecode: "10:3:0")

		gtr.autoStrum(chord: intro_Gb, timecode: "11:1:0")
		gtr.allNotesOff(timecode: "11:2:47")
		gtr.autoStrum(chord: intro_Eb, timecode: "11:2:48")
		gtr.allNotesOff(timecode: "11:4:63")


		
	}
}
