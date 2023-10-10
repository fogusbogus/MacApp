//
//  midiGuitarGeneratorTests.swift
//  midiGuitarGeneratorTests
//
//  Created by Matt Hogg on 08/10/2023.
//

import XCTest
@testable import midiGuitarGenerator

class TimeSignatureEvent_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
    func testTimeSignatureEventCreationWithNumeratorAndDenominator() throws {
		try XCTAssertNoThrow(TimeSignatureEvent(numerator:4, denominator: 4))
    }

    func testTimeSignatureEventCreationWithInvalidNumerator() throws {
		try XCTAssertThrowsError(TimeSignatureEvent(numerator:0, denominator: 4))
    }

    func testTimeSignatureEventCreationWithInvalidDenominator() throws {
		try XCTAssertThrowsError(TimeSignatureEvent(numerator:4, denominator: 3))
    }
	
    func testTimeSignatureEventCreationWithText() throws {
		try XCTAssertNoThrow(TimeSignatureEvent(timeSignature: "4/4"))
    }
	
    func testTimeSignatureEventCreationWithTextAndInvalidSeparator() throws {
		try XCTAssertThrowsError(TimeSignatureEvent(timeSignature: "4.4"))
    }
	
    func testTimeSignatureEventCreationWithTextAndInvalidNumerator() throws {
		try XCTAssertThrowsError(TimeSignatureEvent(timeSignature: "/4"))
    }
	
    func testTimeSignatureEventCreationWithTextAndInvalidNumeratorNumber() throws {
		try XCTAssertThrowsError(TimeSignatureEvent(timeSignature: "0/4"))
    }
	
    func testTimeSignatureEventCreationWithTextAndInvalidDenominator() throws {
		try XCTAssertThrowsError(TimeSignatureEvent(timeSignature: "1/"))
    }
	
    func testTimeSignatureEventCreationWithTextAndInvalidDenominatorNumber() throws {
		try XCTAssertThrowsError(TimeSignatureEvent(timeSignature: "1/5"))
    }

}
