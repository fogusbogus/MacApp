import XCTest
@testable import UKBankHolidays

final class UKBankHolidaysTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(UKBankHolidays().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
