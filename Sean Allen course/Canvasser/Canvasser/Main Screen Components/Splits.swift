//
//  Splits.swift
//  Canvasser
//
//  Created by Matt Hogg on 03/02/2021.
//

import Foundation
import SwiftUI

class Splits : ObservableObject, SplitItemSelectedDelegate {
	
	init(noOfSplits: Int) {
		self.noOfSplits = noOfSplits
		if noOfSplits > 0 {
			getSplitItem(noOfSplits - 1)
		}
	}
	
	func selected(item: SplitItem) {
		splitItems.forEach { (si) in
			if si.number != item.number {
				si.isSelected = false
			}
		}
		update.toggle()
	}
	
	@discardableResult
	func getSplitItem(_ index : Int) -> SplitItem {
		while splitItems.count <= index {
			splitItems.append(SplitItem(number: splitItems.count + 1, delegate: self))
		}
		return splitItems[index]
	}
	
	var noOfSplits : Int = 0 {
		didSet {
			
			for i in 0..<noOfSplits {
				getSplitItem(i)
			}
		}
	}
	
	var splitItems : [SplitItem] = []
	
	@Published var update = false
}

protocol SplitItemSelectedDelegate {
	func selected(item: SplitItem)
}

class SplitItem {
	
	init(number num: Int, isSelected select : Bool = false, delegate del: SplitItemSelectedDelegate? = nil) {
		number = num
		isSelected = select
		delegate = del
	}
	
	var delegate : SplitItemSelectedDelegate? = nil
	
	var number : Int
	var isSelected : Bool = false {
		didSet {
			if isSelected {
				delegate?.selected(item: self)
			}
		}
	}
	
	var visible = true
	
	func backColor() -> Color {
		return isSelected ? Color("Splits.selected.back") : Color("Splits.deselected.back")
	}
	func textColor() -> Color {
		return isSelected ? Color("Splits.selected.fore") : Color("Splits.deselected.fore")
	}
	
	
}
