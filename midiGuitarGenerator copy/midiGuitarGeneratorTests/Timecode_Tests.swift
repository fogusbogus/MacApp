//
//  Timecode_Tests.swift
//  midiGuitarGeneratorTests
//
//  Created by Matt Hogg on 09/10/2023.
//

import XCTest
@testable import midiGuitarGenerator

class TimeCode_Tests: XCTestCase {
	
	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func getTimeline() throws -> Timeline {
		let ret = Timeline()
		ret.addEvent(position: 0, event: try TimeSignatureEvent(numerator: 4, denominator: 4))
		ret.addEvent(position: 384, event: try TimeSignatureEvent(numerator: 7, denominator: 8))
		let delta = ret.getBarDelta(2)
		ret.addEvent(position: delta, event: try TimeSignatureEvent(numerator: 4, denominator: 4))
		return ret
	}
	
	func testTimelineTimecode() throws {
		let timeline = try? getTimeline()
		XCTAssertEqual(TimeCode.translateToTimeCode(720, timeline: timeline), "3:1:0")
	}
	
	func testTimelineTimecodeTranslateToDelta() throws {
		let timeline = try? getTimeline()
		XCTAssertEqual(TimeCode.translateToDelta("1:4:0", timeline: timeline), 288)
	}
	
	func testTimelineTimecodeTranslateToDelta2() throws {
		let timeline = try? getTimeline()
		XCTAssertEqual(TimeCode.translateToDelta("2:1:0", timeline: timeline), 384)
	}
	
	
}
