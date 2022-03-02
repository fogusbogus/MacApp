//
//  main.swift
//  WordPath
//
//  Created by Matt Hogg on 15/02/2022.
//

import Foundation


//var dict : [String] = ["test", "tent", "rest", "rent", "tint", "ting", "rant", "ping", "pint", "pant"]

var dict : [String] = []
do {
	let path: String = "/Users/matt/XCode/Projects/Games/WordChallenge/WordPath/WordPath/Dictionary.txt"
	let file = try String(contentsOfFile: path)
	dict = file.components(separatedBy: "\r\n")
} catch let error {
	Swift.print("Fatal Error: \(error.localizedDescription)")
}

let nwc = NextWordCalculator()
//print(dict)
do {
	try print(nwc.CalculatePaths(dictionary: dict, startWord: "quid", endWord: "jack"))
}
catch let error {
	print("E: \(error)")
}

