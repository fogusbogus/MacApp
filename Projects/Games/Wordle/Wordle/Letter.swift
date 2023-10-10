//
//  Letter.swift
//  Wordle
//
//  Created by Matt Hogg on 07/02/2022.
//

import SwiftUI

struct Letter: View {
	
	var letter: String
	var status: WordleStatus
	var isNewGuess: Bool
	
	func getBackcolor() -> Color {
		switch status {
			case .correct:
				return .green
			case .incorrect:
				return .gray
			case .wrongPlace:
				return .orange
			case .unknown:
				return .black
		}
	}
	
	func getForecolor() -> Color {
		switch status {
			case .correct:
				return .white
			case .incorrect:
				return .white
			case .wrongPlace:
				return .white
			case .unknown:
				return .gray
		}
	}
	
    var body: some View {
		Text(isNewGuess ? " " : letter)
			.foregroundColor(getForecolor())
			.frame(width:16)
			.padding(8)
			.background(getBackcolor())
			.roundedBorder(radius: 8, color: getBackcolor(), width: 1, outerBorderColor: .primary)
    }
}

struct Letter_Previews: PreviewProvider {
    static var previews: some View {
		Letter(letter: "A", status: .wrongPlace, isNewGuess: false)
			.preferredColorScheme(.dark)
    }
}

extension View {
	func roundedBorder(radius: CGFloat, color: Color, width: CGFloat = 2, outerBorderColor: Color = .clear, outerBorderSize: CGFloat = 2) -> some View {
		return self
			.background(Color(UIColor.systemBackground))
			.cornerRadius(radius)
			.padding(width)
			.background(color)
			.cornerRadius(radius)
			.overlay(
				RoundedRectangle(cornerRadius: radius)
					.strokeBorder(outerBorderColor, lineWidth: outerBorderSize, antialiased: true)
					
			)
	}
}
