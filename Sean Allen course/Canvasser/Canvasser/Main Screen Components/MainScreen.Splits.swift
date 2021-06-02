//
//  MainScreen.Splits.swift
//  Canvasser
//
//  Created by Matt Hogg on 03/02/2021.
//

import SwiftUI

struct MainScreen_Splits: View {
	
	@ObservedObject var splits : Splits
	
	init(numOfSplits: Int) {
		splits = Splits(noOfSplits: numOfSplits)
	}
	
	func filter(_ allowed: [Int]) {
		splits.splitItems.forEach { (si) in
			si.visible = allowed.contains(si.number)
		}
		splits.update.toggle()
	}
	
	private var _selected : Int = 0
	
	
	
	var body: some View {
		ScrollView(.horizontal) {
			ScrollViewReader { svr in
				HStack {
					ForEach(0..<splits.splitItems.count, id:\.self) { idx in
						
						SplitNumber(item: $splits.splitItems[idx], paddingLeft: 24)
							.cornerRadius(4)
						
					}
				}
				.padding([.leading, .trailing], 100)
				.padding([.top,.bottom], 32)
				.onAppear(perform: {
					svr.scrollTo(0)
				})
				.onReceive(splits.$update, perform: { _ in
					let scroll : Int? = splits.splitItems.firstIndex(where: { (si) -> Bool in
						return si.isSelected
					})
					if scroll != nil {
						withAnimation { () -> Void in
							svr.scrollTo(scroll!, anchor: .center)
						}
					}
				})
			}
		}
		//.background(Color.gray)
		
	}
}

struct SplitNumber : View {
	
	@Binding var item : SplitItem
	
	var paddingLeft: Int
	
	var body : some View {
		
		if item.visible {
			Text("\(item.number)")
				.font(.system(.largeTitle))
				.padding(.all, 16)
				.cornerRadius(12)
				.background(item.backColor())
				.foregroundColor(item.textColor())
				.border(Color("Splits.border"), width: 1)
				.padding(.leading, CGFloat(paddingLeft))
				.onTapGesture {
					item.isSelected = true
				}
		}
		else {
			Text("\(item.number)")
				.font(.system(.largeTitle))
				.padding(.all, 16)
				.cornerRadius(12)
				.background(item.backColor())
				.foregroundColor(item.textColor())
				.border(Color("Splits.border"), width: 1)
				.padding(.leading, CGFloat(paddingLeft))
				.onTapGesture {
					item.isSelected = true
				}
				.hidden()
		}
	}
}

protocol SplitNumberDelegate {
	func selected(split: SplitNumber)
}

struct MainScreen_Splits_Previews: PreviewProvider {
	static var previews: some View {
		MainScreen_Splits(numOfSplits: 32)
	}
}
