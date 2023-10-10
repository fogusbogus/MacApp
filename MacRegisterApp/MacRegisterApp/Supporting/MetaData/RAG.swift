//
//  RAG.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 29/06/2023.
//

import Foundation
import AppKit

enum RAGStatus  {
	case red, amber, green
	
	var cgColor: CGColor {
		get {
			switch self {
				case .red:
					return .init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
				case .amber:
					return .init(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0)
				case .green:
					return .init(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
			}
		}
	}
	
	var symbol: String {
		get {
			switch self {
				case .red:
					return "🔴"
				case .amber:
					return "🟡"
				case .green:
					return "🟢"
			}
		}
	}
}
