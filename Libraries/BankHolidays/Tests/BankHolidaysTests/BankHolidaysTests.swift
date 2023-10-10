import XCTest
@testable import BankHolidays

final class BankHolidaysTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(BankHolidays().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
