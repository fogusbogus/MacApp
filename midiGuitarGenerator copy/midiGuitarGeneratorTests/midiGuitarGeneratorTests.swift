//
//  midiGuitarGeneratorTests.swift
//  midiGuitarGeneratorTests
//
//  Created by Matt Hogg on 08/10/2023.
//

import XCTest
@testable import midiGuitarGenerator

class midiGuitarGeneratorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
	let chordArray: [Chord] = [
		Chord(collection: "Test", name: "C", version: 1, desc: "C Major"),
		Chord(collection: "Test", name: "C", version: 2, desc: "C Major (2nd Inversion)"),
		Chord(collection: "Test", name: "Fmaj7", desc: "C Major 7th")
	]

    func testChordArrayFindCaseInsensitive() throws {
		XCTAssertNotNil(chordArray.find(collection: "TEST", name: "c"), "Find chord with first version and case-insensitive text")
    }

    func testChordArrayFindCaseInsensitiveAndNotFirstChordInArray() throws {
		XCTAssertNotNil(chordArray.find(collection: "TEST", name: "Fmaj7"), "Find chord with first version and case-insensitive text")
    }

    func testChordArrayCannotFind() throws {
		XCTAssertNil(chordArray.find(collection: "TEST", name: "F7"), "Fail to find chord with first version and case-insensitive text")
    }

    func testChordArrayFindCaseInsensitiveWithSpecificVersion() throws {
		XCTAssertEqual(chordArray.find(collection: "TEST", name: "c")?.version ?? 0, 1)
    }

    func testChordArrayFindCaseInsensitiveWithSpecificVersionThatIsNot1() throws {
		XCTAssertEqual(chordArray.find(collection: "TEST", name: "c", version: 2)?.version ?? 0, 2)
    }

}
