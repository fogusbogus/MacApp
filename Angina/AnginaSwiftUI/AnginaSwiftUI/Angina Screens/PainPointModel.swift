//
//  PainPointModel.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 31/12/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import Foundation

class PainPointModel : ObservableObject, PainPointDelegate {
	func painChanged(painPoint: PainPoint) {
		update.toggle()
	}
	
	@Published var page : [String] = []
	
	var currentPage : String {
		get {
			if page.count == 0 {
				return ""
			}
			return page.last!
		}
	}
	
	func goBack() {
		if page.count > 0 {
			page.removeLast()
		}
	}
	
	@Published var update : Bool = false
	
	@Published var action : String = "" {
		didSet {
			switch action {
				case "":
					return
				
				case "save":
					points.forEach { (pp) in
						pp.pain = 0
					}
					
				default:
					return
			}
			//action = ""
			update.toggle()
		}
	}
	
	private var _points : [PainPoint] = []
	var points : [PainPoint] {
		get {
			if _points.count == 0 {
				_points.append(PainPoint(Name: "HEAD", x: 0.215, y: 0.015, delegate: self))
				_points.append(PainPoint(Name: "RSHD", x: 0.11,  y: 0.19,  delegate: self))
				_points.append(PainPoint(Name: "LSHD", x: 0.32,  y: 0.19,  delegate: self))
				_points.append(PainPoint(Name: "RCST", x: 0.14,  y: 0.28,  delegate: self))
				_points.append(PainPoint(Name: "LCST", x: 0.29,  y: 0.28,  delegate: self))
				_points.append(PainPoint(Name: "STOM", x: 0.215, y: 0.36,  delegate: self))
				_points.append(PainPoint(Name: "GUT",  x: 0.215, y: 0.5,   delegate: self))
				_points.append(PainPoint(Name: "RFOR", x: 0.05,  y: 0.48,  delegate: self))
				_points.append(PainPoint(Name: "LFOR", x: 0.38,  y: 0.48,  delegate: self))
				
				_points.append(PainPoint(Name: "NECK", x: 0.735, y: 0.13,  delegate: self))
				_points.append(PainPoint(Name: "SPIN", x: 0.735, y: 0.25,  delegate: self))
				_points.append(PainPoint(Name: "LTRI", x: 0.59,  y: 0.33,  delegate: self))
				_points.append(PainPoint(Name: "RTRI", x: 0.882, y: 0.33,  delegate: self))
				_points.append(PainPoint(Name: "LLMB", x: 0.68,  y: 0.45,  delegate: self))
				_points.append(PainPoint(Name: "RLMB", x: 0.792, y: 0.45,  delegate: self))
			}
			return _points
		}
		set {
			_points = newValue
		}
	}
	
	func PainPointsSelected() -> [PainPoint] {
		return points.filter { (pp) -> Bool in
			return pp.pain > 0
		}
	}
	
}
