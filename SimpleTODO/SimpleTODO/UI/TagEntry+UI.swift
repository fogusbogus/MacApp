//
//  TagEntry+UI.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 28/07/2023.
//

import SwiftUI

class TagDeclaration : Hashable {
	static func == (lhs: TagDeclaration, rhs: TagDeclaration) -> Bool {
		return lhs.id == rhs.id
	}
	
	init(id: String, text: String, colorHex: String? = nil) {
		self.id = id
		self.text = text
		self.colorHex = colorHex ?? "#93FFA2"
	}
	
	var id: String
	var text: String
	var colorHex: String
	private(set) var uuid = UUID()
	var settings: Settings_Tag?
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(text)
	}
	
	var requiresCreating: Bool { id.isEmpty }
	
	static func fromTagPoolItem(_ tag: TagPool) -> TagDeclaration {
		return TagDeclaration(id: String(describing: tag.objectID), text: tag.name ?? "", colorHex: tag.colorHex)
	}
	
	func getColor(alpha: Double = 1.0) -> CGColor {
		return ColorHelper.Color(hex: colorHex, alpha: alpha, defaultColor: .init(red: 0, green: 1, blue: 0, alpha: 1))
	}
}

protocol TagPillDelegate {
	func delete(tag: TagDeclaration)
}
struct TagPill: View {

	struct Options {
		var padding: CGFloat = 6
		var alpha: Double = 0.4
		var textColor: Color = .black
		var cornerSize = Constants.cornerSize
		var borderWidth = Constants.borderWidth
		var borderColor: Color?
	}
	
	/// Variables
	var tag = TagDeclaration(id: "", text: "Tag text")
	var delegate: TagPillDelegate?
	var options: Options = Options()
	

	var body: some View {
		HStack {
			Button {
				delegate?.delete(tag: tag)
			} label: {
				Image(systemName: "xmark.circle")
			}
			Text(tag.text)
				.foregroundColor(options.textColor)
		}
		.padding([.leading, .top, .bottom], options.padding)
		.padding(.trailing, options.padding * 2)
		.overlay {
			RoundedRectangle(cornerRadius: options.cornerSize).stroke(Color(cgColor: options.borderColor as! CGColor) ?? Color("Colors/border"), lineWidth: options.borderWidth)
				.background(Color(cgColor: tag.getColor(alpha: options.alpha)))
				.cornerRadius(options.cornerSize)
		}
	}
}

struct CurrentTags: View {
	
	var tags: [TagDeclaration]
	var delegate: TagPillDelegate?
	
	var body: some View {
		Grid {
			ForEach(tags, id:\.self) { tag in
				TagPill(tag: tag, delegate: delegate)
			}
		}
	}
}

class TagCollection {
	
	typealias ProcessDelegate = (toAdd: [TagDeclaration], toRemove: [TagDeclaration])
	
	init(_ tags: [TagDeclaration] = []) {
		self.tags = tags
		self.original.append(contentsOf: tags)
	}
	
	private var original: [TagDeclaration] = []
	
	var tags: [TagDeclaration]
	
	func add(_ tag: TagDeclaration) {
		remove(tag)
		tags.append(tag)
	}
	
	func remove(_ tag: TagDeclaration) {
		tags.removeAll(where: {$0.uuid == tag.uuid})
	}
	
	func reset() {
		tags = original
	}
	
	func process(_ delegate: (ProcessDelegate) -> Void) {
		let adds = tags.filter { tag in
			return !original.contains(where: { $0.uuid == tag.uuid })
		}
		let removes = original.filter { tag in
			return !tags.contains(where: {$0.uuid == tag.uuid})
		}
		delegate((toAdd: adds, toRemove: removes))
	}
}

struct TagEntry_UI: View {
	
	var ticket: Ticket
	
	var tags: TagCollection = TagCollection()
	
	var body: some View {
		VStack {
			CurrentTags(tags: ticket.getTagDeclarations().whenEmpty([TagDeclaration(id: "", text: "temp tag")]), delegate: self)
		}
	}
}

extension TagEntry_UI : TagPillDelegate {
	func delete(tag: TagDeclaration) {
		tags.remove(tag)
	}
	
	
}

struct TagEntry_UI_Previews: PreviewProvider {
	static var ticket: Ticket {
		get {
			return Ticket.getAll().first ?? Ticket()
		}
	}
	static var previews: some View {
		TagEntry_UI(ticket: ticket)
	}
}
