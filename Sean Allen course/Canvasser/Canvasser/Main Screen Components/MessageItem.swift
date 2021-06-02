//
//  MessageItem.swift
//  Canvasser
//
//  Created by Matt Hogg on 20/01/2021.
//

import SwiftUI

struct MessageItem: View {
	
	var calcHeight : CGFloat = 48
	@State var icoHeight = BindingCGFloat(height: 48)
	
	var body: some View {
		VStack {
			HStack(alignment: .top, spacing: 24, content: {
				
				VStack {
					Image(systemName: "message.fill")
						.resizable()
						.scaledToFit()
						.frame(width: 48, height: 48, alignment: .center)
						.aspectRatio(contentMode: .fill)
						.foregroundColor(.green)
					//.padding(.top, 16)
				}
				
				VStack(alignment: .leading, spacing: 8, content: {
					Text("Message from Electoral Services")
						.bold()
					Text("A resident in this road has reported a flooding. Please can you confirm this?\n\n\nIt is likely that the road will be closed.")
				})
				Spacer()
			})
			.padding([.leading, .trailing, .top, .bottom], 24)
			.border(Color.white, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
			.background(Color.gray)
		}
		.padding([.leading, .trailing], 24)
	}
}

class BindingCGFloat : ObservableObject {
	init(height: CGFloat) {
		self.height = height
	}
	
	var oldValue : CGFloat = 0
	var height : CGFloat = 0 {
		willSet {
			oldValue = newValue
		}
		didSet {
			if height != oldValue {
				update.toggle()
			}
		}
	}
	
	@Published var update : Bool = false
}


struct MessageLines : View {
	@Binding var icoHeight : BindingCGFloat
	var body : some View {
		
		VStack(alignment: .leading, spacing: 8, content: {
			Text("Message from Electoral Services")
				.bold()
			Text("A resident in this road has reported a flooding. Please can you confirm this?\n\n\nIt is likely that the road will be closed.")
		})
		
	}
}

struct MessageItem_Previews: PreviewProvider {
	static var previews: some View {
		MessageItem()
			.preferredColorScheme(.dark)
			.previewLayout(.device)
			.previewDevice("iPad Pro (9.7-inch)")
	}
}
