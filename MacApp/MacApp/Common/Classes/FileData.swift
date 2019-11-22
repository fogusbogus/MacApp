//
//  FileData.swift
//  Common
//
//  Created by Matt Hogg on 20/11/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

/*
Although this allows us to read the file line by line, the data is held in memory. It's a bit pointless and we should probably just treat it as a big string.

The problem is when we are dealing with huge files and we just want to grab a small portion of it. The solution doesn't scale too well.

Something for you to do in the future is to look up ways of reading from a stream of data without having to read the whole thing in one go. It would be nice to traverse the stream in a random fashion.

The class as it is already has the makings of a random access streamer!! We just need to know how to process the detail.

This is not of vital importance for the moment but a nice-to-have.

MH 20-Nov-19
*/
public class FileData {
	
	public init() {
		
	}
	
	public func Close() {
		Path = ""
		_data = nil
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
			return _pos == Length
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
	
	private var _data : Data? = nil
	
	public func ReadToNext(_ charSequence: String, _ includeCharSequence: Bool = false, _ encoding: String.Encoding = .utf8) -> String {
		
		if _data == nil {
			let url = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first
			let fileOut = url?.appendingPathComponent(Path)
			do {
				_data = try Data(contentsOf: fileOut!, options: .mappedIfSafe)
			}
			catch let error {
				print(error)
				return ""
			}
		}
		
		do {
			let textData = _data!.subdata(in: Int(_pos)..<Int(Length))
			var text = String(data: textData, encoding: encoding)!
			let hasText = text.indexOf(charSequence) >= 0
			text = text.before(charSequence, returnAllWhenMissing: true)
			Position = Position + UInt64(text.length(encoding: encoding)) + UInt64(charSequence.length(encoding: encoding))
			if includeCharSequence {
				if hasText {
					text += charSequence
				}
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
			let url = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first
			let fileOut = url?.appendingPathComponent(path)
			let attrs = try FileManager.default.attributesOfItem(atPath: fileOut?.path ?? "")
			ret = attrs[FileAttributeKey.size] as! UInt64
		}
		catch let error {
			print(error)
		}
		return ret
	}
}
