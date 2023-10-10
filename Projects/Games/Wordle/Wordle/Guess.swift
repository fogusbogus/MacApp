//
//  Guess.swift
//  Wordle
//
//  Created by Matt Hogg on 07/02/2022.
//

import SwiftUI
import Combine

class CounterClass {
	var counter = 0
	
	func countSomething() {
		counter += 1
	}
	
	var theCount: String {
		get {
			return "\(counter)"
		}
	}
}

protocol NewWordleAdded {
	static func wordleAdded(wordle: String)
}

struct Guess: View {
	
	var theWordle: String
	var wordles: [[(String, WordleStatus)]]
	var newGuess: Bool = false
	@State var guess: String
	var maxLength = 5
	var delegate: NewWordleAdded

	
    var body: some View {
		VStack {
			VStack {
				ForEach((0..<wordles.count), id:\.self) { wordleIdx in
					let wordle = wordles[wordleIdx]
					HStack(alignment:.top, spacing: 8) {
						ForEach((0..<wordle.count), id:\.self) { idx in
							let item = wordle[idx]
							Letter(letter: item.0, status: item.1, isNewGuess: newGuess)
							
							
						}
						Spacer()
					}
					.padding()
				}
			}
			Spacer()
			if !newGuess {
				TextField("Guess the word", text: $guess)
					.onReceive(Just(guess)) { _ in limitText(maxLength) }
					.textFieldStyle(.roundedBorder)
					.autocapitalization(/*@START_MENU_TOKEN@*/.allCharacters/*@END_MENU_TOKEN@*/)
					.padding(8)
					.onSubmit {
						//delegate.wordleAdded(wordle: guess)
					}
			}
		}
    }
	
	//Function to keep text length in limits
	func limitText(_ upper: Int) {
		if guess.lengthOfBytes(using: .utf8) > upper {
			guess = String(guess.prefix(upper))
		}
	}
}

struct Guess_Previews: PreviewProvider, NewWordleAdded {
	static func wordleAdded(wordle: String) {
		
	}
	
	
	static var wordles: [[(String, WordleStatus)]] = []
	
    static var previews: some View {
		Guess(theWordle: "FRESH", wordles: wordles, newGuess: false, guess: "", delegate: self as! NewWordleAdded)
			.preferredColorScheme(.dark)
    }
}
