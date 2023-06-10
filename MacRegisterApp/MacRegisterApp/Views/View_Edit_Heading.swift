//
//  Heading.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 01/06/2023.
//

import SwiftUI

protocol View_Edit_Heading_Delegate {
	func edit()
	func delete()
	func save()
	func cancel()
	
	func canEdit() -> Bool
	func canDelete() -> Bool
	func inEditMode() -> Bool
}

struct View_Edit_Heading: View {
	
	init(_ text: String = "", delegate: View_Edit_Heading_Delegate? = nil) {
		self.text = text
		self.delegate = delegate
	}
	
	var text: String = ""
	
	private var delegate: View_Edit_Heading_Delegate?
	
    var body: some View {
		HStack(alignment: .center, spacing: 24) {
			Text(text)
				.font(.largeTitle)
			Spacer()
			if delegate?.inEditMode() ?? false {
				Button {
					delegate?.save()
				} label: {
					Image(systemName: "checkmark.circle")
						.foregroundColor(.green)
				}
				.buttonStyle(.plain)
				Button {
					delegate?.cancel()
				} label: {
					Image(systemName: "xmark.circle")
						.foregroundColor(.red)
				}
				.buttonStyle(.plain)
			} else {
				Button {
					delegate?.edit()
				} label: {
					Image(systemName: "pencil")
						.foregroundColor(.accentColor)
				}
				.buttonStyle(.plain)
				.disabled(!(delegate?.canEdit() ?? false))
				Button {
					delegate?.delete()
				} label: {
					Image(systemName: "trash")
						.foregroundColor(.pink)
				}
				.buttonStyle(.plain)
				.disabled(!(delegate?.canDelete() ?? false))
			}
		}
    }
}

struct Heading_Previews: PreviewProvider {
    static var previews: some View {
        View_Edit_Heading()
    }
}
