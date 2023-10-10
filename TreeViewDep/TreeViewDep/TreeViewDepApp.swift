//
//  TreeViewDepApp.swift
//  TreeViewDep
//
//  Created by Matt Hogg on 24/04/2023.
//

import SwiftUI
import TreeView


class TreeViewData {
	static var shared = TreeViewData()
	private init() {
		treeView = TreeView()
		options = TreeViewUIOptions()
		options.collapsedSymbol = "+"
		options.expandedSymbol = "-"
		
		options.indentSize = 16
		let first = treeView.append(text: "Genesis", creator: {ArtistNode()})
		first.key = "GENESIS"
		let albums = first.appendNodes(contentsOf: [
			("FGTR", "From Genesis To Revelation"),
			("T", "Trespass"),
			("NC", "Nursery Cryme"),
			("F", "Foxtrot"),
			("SEBTP", "Selling England By The Pound"),
			("TLLDOB", "The Lamb Lies Down On Broadway"),
			("TOTT", "Trick Of The Tail"),
			("WAW", "Wind and Wuthering"),
			("ATTWT", "...And Then There Were Three"),
			("D", "Duke"),
			("A", "Abacab"),
			("G", "Genesis"),
			("IT", "Invisible Touch"),
			("WCD", "We Can't Dance"),
			("CAS", "Calling All Stations")
		], creator: {AlbumNode()})
		albums.forEach { album in
			switch album.key {
				case "FGTR":
					album.releaseYear = 1969
					
				case "T":
					album.releaseYear = 1970
					
				case "NC":
					album.releaseYear = 1971
					
				case "F":
					album.releaseYear = 1972
					
					
				case "SEBTP":
					album.releaseYear = 1973
					
				case "TLLDOB":
					album.releaseYear = 1974
					
				case "TTOT":
					album.releaseYear = 1976
					
				case "WAW":
					album.releaseYear = 1976
				
				case "ATTWT":
					album.releaseYear = 1978
				
				case "D":
					album.releaseYear = 1980
				
				case "A":
					album.releaseYear = 1981
				
				case "G":
					album.releaseYear = 1983
				
				case "IT":
					album.releaseYear = 1986
				
				case "WCD":
					album.releaseYear = 1991
				
				case "CAS":
					album.releaseYear = 1997
					
				default:
					break
				
			}
		}
		
		first["FGTR"]?.appendNodes(contentsOf: [
			("WTSTTS", "Where the Sour Turns to Sweet"),
			("ITB", "In the Beginning"),
			("FS", "Fireside Song"),
			("TS", "The Serpent"),
			("AIVW", "Am I Very Wrong?"),
			("ITW", "Into the Wilderness"),
			("TC", "The Conqueror"),
			("IH", "In Hiding"),
			("OD", "One Day"),
			("W", "Window"),
			("IL", "In Limbo"),
			("TSS", "The Silent Sun"),
			("APTCMO", "A Place to Call My Own")
		]) {
			return TrackNode(lyrics: "", musicBy: "Banks/Gabriel/Phillips/Rutherford", lyricsBy: "Banks/Gabriel/Phillips/Rutherford")
		}.iterate { node, idx in
			switch node.key {
				case "WTSTTS":
					node.lyrics = "We're waiting for you\nCome and join us now\nWe need you with us\nCome and join us now\nLook inside your mind\nSee the darkness is creeping out\nI can see in the softness there\nWhere the sunshine is gliding in\nFill your mind with love\nFind the world of future glory\nYou can meet yourself\nWhere the sour turns to sweet\nLeave your ugly selfish shell\nTo melt in the glowing flames\nCan you sense the change?\nSee your eyes, now listen\nWe're waiting for you\nCome and join us now\nWe want you with us\nCome and join us now\nPaint your face all white\nTo show the peace inside\nDrift away while the saffron burns\nTo the land where the rainbow ends\nCan you sense the change?\nSee your eyes in focus\nWe're waiting for you\nCome and join us now\nWe need you with us\nCome and join us now\nWe're waiting for you\nCome and join us now\nWe need you with us\nCome and join us now\nWe want you with us\nCome and join us now\nWe need you with us\nCome and join us now"
					
				default:
					break
			}
		}
		
		first["T"]?.appendNodes(contentsOf: [
			("LFS", "Looking for Someone"),
			("WM", "White Mountain"),
			("VOA", "Visions of Angels"),
			("S", "Stagnation"),
			("D", "Dusk"),
			("TK", "The Knife")
		], creator: {TrackNode()})
		.forEach { node in
			switch node.key {
				default:
					break
			}
		}

		first["NC"]?.appendNodes(contentsOf: [
			("", "The Musical Box"),
			("", "For Absent Friends"),
			("", "The Return of the Giant Hogweed"),
			("", "Seven Stones"),
			("", "Harold the Barrel"),
			("", "Harlequin"),
			("", "The Fountain of Salmacis")
		], creator: {TrackNode()})
		.forEach { node in
			switch node.key {
				default:
					break
			}
		}

		
		albums[3].append(contentsOf: [
			"Watcher of the Skies",
			"Time Table",
			"Get 'Em Out by Friday",
			"Can-Utility and the Coastliners",
			"Horizons",
			"Supper's Ready"
		], creator: {TrackNode()})
		albums[4].append(contentsOf: [
			"Dancing with the Moonlit Knight",
			"I Know What I Like (In Your Wardrobe)",
			"Firth of Fifth",
			"More Fool Me",
			"The Battle of Epping Forest",
			"After the Ordeal",
			"The Cinema Show",
			"Aisle of Plenty"
		], creator: {TrackNode()})
		albums[5].append(contentsOf: [
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
		], creator: {TrackNode()})
		albums[6].append(contentsOf: [
			"Dance on a Volcano",
			"Entangled",
			"Squonk",
			"Mad Man Moon",
			"Robbery, Assault & Battery",
			"Ripples",
			"A Trick of the Tail",
			"Los Endos"
		], creator: {TrackNode()})
		albums[7].append(contentsOf: [
			"Eleventh Earl of Mar",
			"One for the Vine",
			"Your Own Special Way",
			"Wot Gorilla",
			"All in a Mouse's Night",
			"Blood on the Rooftops",
			"Unquiet Slumber for the Sleepers...",
			"...In That Quiet Earth",
			"Afterglow"
		], creator: {TrackNode()})
		albums[8].append(contentsOf: [
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
		], creator: {TrackNode()})
		albums[9].append(contentsOf: [
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
		], creator: {TrackNode()})
		albums[9].append(text: "B-Sides").selectable = false
		albums[9].append(contentsOf: [
			"Vancouver", "Open Door", "Evidence of Autumn"
		], creator: {TrackNode()})
		albums[10].append(contentsOf: [
			"Abacab",
			"No Reply at All",
			"Me and Sarah Jane",
			"Keep It Dark",
			"Dodo/Lurker",
			"Whodunnit?",
			"Man on the Corner",
			"Like It or Not",
			"Another Record"
		], creator: {TrackNode()})
		albums[10].append(text: "B-Sides").selectable = false
		albums[10].append(contentsOf: [
			"Naminanu", "Submarine", "You Might Recall", "Me & Virgil"
		], creator: {TrackNode()})
		albums[11].append(contentsOf: [
			"Mama",
			"That's All",
			"Home By The Sea",
			"Second Home By The Sea",
			"Illegal Alien",
			"Taking It All Too Hard",
			"Just a Job to Do",
			"Silver Rainbow",
			"It's Gonna Get Better"
		], creator: {TrackNode()})
		albums[12].append(contentsOf: [
			"Invisible Touch",
			"Tonight Tonight Tonight",
			"Land of Confusion",
			"In Too Deep",
			"Anything She Does",
			"Domino",
			"Throwing It All Away",
			"The Brazilian"
		], creator: {TrackNode()})
		albums[12].append(text: "B-Sides").selectable = false
		albums[12].append(contentsOf: [
			"I'd Rather Be You", "Feeding the Fire", "Do the Neurotic"
		], creator: {TrackNode()})
		albums[13].append(contentsOf: [
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
		], creator: {TrackNode()})
		albums[13].append(text: "B-Sides").selectable = false
		albums[13].append(contentsOf: [
			"Heart's on Fire", "On the Shoreline"
		], creator: {TrackNode()})
		albums[14].append(contentsOf: [
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
		], creator: {TrackNode()})
		albums[14].append(text: "B-Sides").selectable = false
		albums[14].append(contentsOf: [
			"7/8", "Sign Your Life Away", "Banjo Man", "Phret", "Run Out of Time", "Anything Now", "Nowhere Else to Turn"
		], creator: {TrackNode()})
		
	}
	
	var treeView: TreeView
	var options: TreeViewUIOptions
}

class AlbumNode: TreeNode {
	override init() {
		self.releaseYear = 2023
	}
	
	init(artwork: CGImage? = nil, releaseYear: Int) {
		super.init()
		self.artwork = artwork
		self.releaseYear = releaseYear
	}
	var artwork: CGImage?
	var releaseYear: Int
	
}

class TrackNode: TreeNode {

	override init() {
		super.init()
		lyrics = ""
		composerMusic = ""
		composerLyrics = ""
		personnel = []
		trackLength = nil
	}
	init(lyrics: String, musicBy: String, lyricsBy: String, personnel: [String] = [], trackLength: TimeInterval? = nil) {
		self.lyrics = lyrics
		self.composerMusic = musicBy
		self.composerLyrics = lyricsBy
		self.personnel = personnel
		self.trackLength = trackLength
	}
	var lyrics: String
	var composerMusic: String
	var composerLyrics: String
	var personnel: [String]
	var trackLength: TimeInterval?
}

class ArtistNode: TreeNode {
	
}

@main
struct TreeViewDepApp: App, TreeViewNotifier, TreeNodeDataProvider {
	
	func createNodes(_ data: [TreeNodeKeyValue], creator: () -> TreeNode) -> [TreeNode] {
		var ret: [TreeNode] = []
		data.forEach { kv in
			let node = creator()
			node.key = kv.key
			node.text = kv.value
			ret.append(node)
		}
		return ret
	}
	
	
	func shellEnv(_ command: String) -> String {
		let task = Process()
		let pipe = Pipe()
		
		task.standardOutput = pipe
		task.standardError = pipe
		task.arguments = ["-cl", command]
		task.launchPath = "/bin/zsh"
		task.launch()
		
		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		let output = String(data: data, encoding: .utf8)!
		
		return output
	}
	
	func getChildren(forNode: TreeNode?) -> [TreeNode] {

		guard forNode != nil else {
			return []
		}
		var ret: [TreeNode] = []
		switch forNode?.keyPath {
			case "GENESIS":
				ret.append(contentsOf: createNodes([
					("FGTR", "From Genesis to Revelation"),
					("T", "Trespass")
				], creator: {
					return AlbumNode()
				}))
			case "GENESIS.FGTR":
				ret.append(contentsOf: createNodes([
					("WTSTTS", "Where the Sour Turns to Sweet"),
					("ITB", "In the Beginning"),
					("FS", "Fireside Song"),
					("TS", "The Serpent"),
					("AIVW", "Am I Very Wrong?"),
					("ITW", "Into the Wilderness"),
					("TC", "The Conqueror"),
					("IH", "In Hiding"),
					("OD", "One Day"),
					("W", "Window"),
					("IL", "In Limbo"),
					("TSS", "The Silent Sun"),
					("APTCMO", "A Place to Call My Own")
				], creator: {
					return TrackNode()
				}))
			default:
				return []
		}
		return ret
	}
	
	func hasChildren(forNode: TreeNode?) -> Bool {
		if let _ = forNode as? TrackNode {
			return false
		}
		return true
//		switch forNode.keyPath {
//			case "GENESIS":
//				return true
//
//			default:
//				return false
//		}
	}
	
	func selectionChanged(node: TreeNode?, data: AnyObject?) {
		//print(data)
		if node != nil {
			//print("\(node!.text) selected")
			print(node!.keyPath)
			if let album = node as? AlbumNode {
				print("\(album.text) (\(album.releaseYear))")
			}
			if let track = node as? TrackNode {
				print(track.lyrics)
			}
		}
		else {
			print("Nothing selected")
		}
	}
	
	var treeView : TreeView {
		get {
			TreeViewData.shared.treeView.notifyDelegate = self
			return TreeViewData.shared.treeView
		}
	}
	
    var body: some Scene {
        WindowGroup {
			ScrollView {
				TreeViewUI(options: TreeViewData.shared.options, treeView: treeView, dataProvider: self)
			}
        }
    }
}
