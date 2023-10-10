import XCTest
@testable import CSVParser

final class CSVParserTests: XCTestCase {
	
	/// process CSV with extra column in penultimate row
	func test_processCSVWithExtraColumnInPenultimateRow() throws {
		let fileContent = "Asset, Label \n \"test\", \"test\" \n \"test\", \"test\"\n \"test\", \"test,\" \n \"test\" \n  "
		let processedFileContent = CSVParser.getArrayFromCSVContent(csv: fileContent, options: CSVParser.Options(trim: true, allowLeadingWhitespaceBeforeEscapes: false))
		
		XCTAssertEqual(processedFileContent.count, 4, "Should have 4 rows")
		
		XCTAssertEqual(processedFileContent[0].count, 2, "Should have two columns")
		XCTAssertEqual(processedFileContent[0][0], "Asset")
		XCTAssertEqual(processedFileContent[0][1], "Label")

		XCTAssertEqual(processedFileContent[1].count, 2, "Should have two columns")
		XCTAssertEqual(processedFileContent[1][0], "\"test\"")
		XCTAssertEqual(processedFileContent[1][1], "\"test\"")

		XCTAssertEqual(processedFileContent[2].count, 2, "Should have two columns")
		XCTAssertEqual(processedFileContent[2][0], "\"test\"")
		XCTAssertEqual(processedFileContent[2][1], "\"test\"")
		
		XCTAssertEqual(processedFileContent[3].count, 3, "Should have two columns")
		XCTAssertEqual(processedFileContent[3][0], "\"test\"")
		XCTAssertEqual(processedFileContent[3][1], "\"test")
		XCTAssertEqual(processedFileContent[3][2], " \n \"test")
	}
	
	func test_return2DArrayOfStringsCorrectly() throws {
		let fileContent = "Header1, Header2 \n Foo, Bar \n Bla, Test"
		
		let processedFileContent = CSVParser.getArrayFromCSVContent(csv: fileContent, options: CSVParser.Options(trim: true, allowLeadingWhitespaceBeforeEscapes: false))

		XCTAssertEqual(processedFileContent.count, 3, "Should have 3 rows")
		
		XCTAssertEqual(processedFileContent[0].count, 2, "Should have 2 columns")
		XCTAssertEqual(processedFileContent[0][0], "Header1")
		XCTAssertEqual(processedFileContent[0][1], "Header2")
		
		XCTAssertEqual(processedFileContent[1].count, 2, "Should have 2 columns")
		XCTAssertEqual(processedFileContent[1][0], "Foo")
		XCTAssertEqual(processedFileContent[1][1], "Bar")

		XCTAssertEqual(processedFileContent[2].count, 2, "Should have 2 columns")
		XCTAssertEqual(processedFileContent[2][0], "Bla")
		XCTAssertEqual(processedFileContent[2][1], "Test")
	}
	
	func test_processCRLFCorrectly() throws {
		let fileContent = "Asset,Label\r\nmatth1.test.co.uk,\"\"\"This\"\" is a test\"\r\nmatth1_2.test.co.uk,\"This, has, commas\"\r\nmatth1_3.test.co.uk,\"\"\"This\"\" has quotes, and commas\""
		
		let processedFileContent = CSVParser.getArrayFromCSVContent(csv: fileContent, options: CSVParser.Options(trim: true, allowLeadingWhitespaceBeforeEscapes: false))
		
		XCTAssertEqual(processedFileContent.count, 4, "Should have 4 rows")
		
		XCTAssertEqual(processedFileContent[0].count, 2, "Should have 2 columns")
		XCTAssertEqual(processedFileContent[0][0], "Asset")
		XCTAssertEqual(processedFileContent[0][1], "Label")
		
		XCTAssertEqual(processedFileContent[1].count, 2, "Should have 2 columns")
		XCTAssertEqual(processedFileContent[1][0], "matth1.test.co.uk")
		XCTAssertEqual(processedFileContent[1][1], "\"This\" is a test")
		
		XCTAssertEqual(processedFileContent[2].count, 2, "Should have 2 columns")
		XCTAssertEqual(processedFileContent[2][0], "matth1_2.test.co.uk")
		XCTAssertEqual(processedFileContent[2][1], "This, has, commas")

		XCTAssertEqual(processedFileContent[3].count, 2, "Should have 2 columns")
		XCTAssertEqual(processedFileContent[3][0], "matth1_3.test.co.uk")
		XCTAssertEqual(processedFileContent[3][1], "\"This\" has quotes, and commas")
	}
	
	func test_trimsWhitespaceFromCellText() throws {
		let fileContent = "  Header1 , Header2 \n  Foo , Bar  "
		
		let processedFileContent = CSVParser.getArrayFromCSVContent(csv: fileContent, options: CSVParser.Options(trim: true, allowLeadingWhitespaceBeforeEscapes: false))
		
		XCTAssertEqual(processedFileContent.count, 2, "Should have 2 rows")
		
		XCTAssertEqual(processedFileContent[0].count, 2, "Should have 2 columns")
		XCTAssertEqual(processedFileContent[0][0], "Header1")
		XCTAssertEqual(processedFileContent[0][1], "Header2")
		
		XCTAssertEqual(processedFileContent[1].count, 2, "Should have 2 columns")
		XCTAssertEqual(processedFileContent[1][0], "Foo")
		XCTAssertEqual(processedFileContent[1][1], "Bar")
	}
	
	func test_returnsAnEmptyArrayIfEmptyContentIsProvided() throws {
		let fileContent = "    "
		
		let processedFileContent = CSVParser.getArrayFromCSVContent(csv: fileContent, options: CSVParser.Options(trim: true, allowLeadingWhitespaceBeforeEscapes: false))
		
		XCTAssertEqual(processedFileContent.count, 0, "Should have 0 rows")
	}
	
	func test_returns2DArrayOfStringsCorrectlyWhenUsingQuotedAreas() throws {
		let fileContent = "\"Header1, extra\", Header2 \n Foo, Bar \n Bla, Test,\n \"With \nNewlines\", Foo"
		
		let processedFileContent = CSVParser.getArrayFromCSVContent(csv: fileContent, options: CSVParser.Options(trim: true, allowLeadingWhitespaceBeforeEscapes: false))
		
		XCTAssertEqual(processedFileContent.count, 5, "Should have 5 rows")
		
		XCTAssertEqual(processedFileContent[0].count, 2, "Should have 2 columns")
		XCTAssertEqual(processedFileContent[0][0], "Header1, extra")
		XCTAssertEqual(processedFileContent[0][1], "Header2")
		
		XCTAssertEqual(processedFileContent[1].count, 2, "Should have 2 columns")
		XCTAssertEqual(processedFileContent[1][0], "Foo")
		XCTAssertEqual(processedFileContent[1][1], "Bar")
		
		XCTAssertEqual(processedFileContent[2].count, 3, "Should have 3 columns")
		XCTAssertEqual(processedFileContent[2][0], "Bla")
		XCTAssertEqual(processedFileContent[2][1], "Test")
		XCTAssertEqual(processedFileContent[2][2], "")
		
		XCTAssertEqual(processedFileContent[3].count, 1, "Should have 1 column")
		XCTAssertEqual(processedFileContent[3][0], "\"With")
		
		XCTAssertEqual(processedFileContent[4].count, 2, "Should have 2 columns")
		XCTAssertEqual(processedFileContent[4][0], "Newlines\"")
		XCTAssertEqual(processedFileContent[4][1], "Foo")
	}

}
