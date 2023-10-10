import UIKit

var str = "Hello, playground"

public class FileData {
	
	init() {
		
	}
	
	public var Path = ""
	
	private var _length = UInt64.zero
	
	public var Length : UInt64 {
		get {
			if _length < 1 {
				//Examine the file data if we can
				_length = getFileSize(path: Path)
			}
			return _length
		}
	}
	
	private var _pos : UInt64 = UInt64.zero
	
	public var Position : UInt64 {
		get {
			return _pos
		}
		set {
			if newValue <= Length {
				_pos = newValue
			}
		}
	}
	
	public var AtEnd : Bool {
		get {
			return _pos == _length
		}
		set {
			_pos = _length
		}
	}
	
	public var AtStart : Bool {
		get {
			return _pos == 0
		}
		set {
			_pos = 0
		}
	}
	
	public func ReadLines(_ callback: (String) -> Void, _ encoding : String.Encoding = .utf8) {
		while !AtEnd {
			callback(ReadLine(encoding))
		}
	}
	
	public func ReadLine(_ encoding: String.Encoding = .utf8) -> String {
		return ReadToNext("\n", false, encoding).trimmingCharacters(in: .newlines)
	}
	
	public func ReadToNext(_ charSequence: String, _ includeCharSequence: Bool = false, _ encoding: String.Encoding = .utf8) -> String {
		
		let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
		let fileOut = url?.appendingPathComponent(Path)
		
		do {
			let data = try Data(contentsOf: fileOut!, options: .mappedIfSafe)
			let textData = data.subdata(in: Int(_pos)..<Int(Length))
			var text = String(data: textData, encoding: encoding)!
			text = text.before(charSequence, returnAllWhenMissing: true)
			if includeCharSequence {
				Position = Position + UInt64(text.length(encoding: encoding)) + UInt64(charSequence.length(encoding: encoding))
			}
			else {
				Position = Position + UInt64(text.length(encoding: encoding))
			}
			return text
		}
		catch let error {
			print(error)
		}
		return ""
	}
	
	private func getFileSize(path: String) -> UInt64 {
		var ret : UInt64 = UInt64.zero
		do {
			let attrs = try FileManager.default.attributesOfItem(atPath: path)
			ret = attrs[FileAttributeKey.size] as! UInt64
		}
		catch let error {
			print(error)
		}
		return ret
	}
}


extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        var indices: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                indices.append(range.lowerBound)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return indices
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

extension String {
	//Returns the substring using from and to
	func substring(from: Int, to: Int) -> String {
		guard from < self.length() else { return "" }
		guard to >= 0 && from >= 0 && from <= to else {
			return ""
		}
		
		let start = index(startIndex, offsetBy: from)
		let end = index(startIndex, offsetBy: to.min(self.length() - 1))
		return String(self[start ... end])
	}
	
	//Returns the substring using from and length
	func substring(from: Int, length: Int) -> String {
		let to = from - 1 + length
		return self.substring(from: from, to: to)
	}
	
	//Returns the substring using from
	func substring(from: Int) -> String {
		let start = index(startIndex, offsetBy: from)
		let end = self.endIndex
		return String(self[start ..< end])    }
	
	//Returns the substring
	func substring(range: NSRange) -> String {
		return substring(from: range.lowerBound, to: range.upperBound)
	}
	
	//Returns the (default) utf8 length of the string
	func length(encoding: String.Encoding = .utf8) -> Int {
		return lengthOfBytes(using: encoding)
	}

	/////////////////////////////////////////////
	// A
	/////////////////////////////////////////////
	
	/// Returns the text after the given sequence
	///
	/// - Parameter sequence: Return the text after this
	/// - Parameter returnAllWhenMissing: If the sequence isn't found, return everything
	/// - Returns: The text after the given sequence
	func after(_ sequence: String, returnAllWhenMissing: Bool = false) -> String {
		if !self.contains(sequence) {
			if returnAllWhenMissing {
				return self
			}
			return ""
		}
		
		let start = index((range(of: sequence)?.upperBound)!, offsetBy: 0)
		let end = self.endIndex
		return String(self[start ..< end])
	}
	
	/////////////////////////////////////////////
	// B
	/////////////////////////////////////////////
	
	/// Returns the text before the given sequence
	///
	/// - Parameters:
	///   - sequence: Return the text before this
	///   - returnAllWhenMissing: If the sequence isn't found, return everything
	/// - Returns: The text before the given sequence
	func before(_ sequence: String, returnAllWhenMissing: Bool = false) -> String {
		if !self.contains(sequence) {
			if returnAllWhenMissing {
				return self
			}
			return ""
		}
		
		let end = index((range(of: sequence)?.upperBound)!, offsetBy: -1)
		let start = self.startIndex
		return String(self[start ..< end])
	}
}

extension Comparable {
	func min(_ subsequent: Self...) -> Self {
		var ret = self
		for item in subsequent {
			if item < ret {
				ret = item
			}
		}
		return ret
	}

}

do {
	
	//Aim:
	//We are going to read from a file, but not the whole content, just a subset of characters
	
	var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
	let fileOut = url?.appendingPathComponent("myFile.txt")
	try "This is the contents of my file\nThis is another line\n\nThis is the last line".write(to: fileOut!, atomically: true, encoding: .utf8)
	
	let fd = FileData()
	fd.Path = fileOut?.path ?? ""
	fd.ReadLines( { (s : String) -> Void in
		print(s)
	})
}
catch let error {
	print(error)
}


