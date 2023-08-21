//
//  Comment+UI.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 07/08/2023.
//

import SwiftUI


struct StandardButton: ButtonStyle {
	
	var background = Color.blue
	var foreground = Color.white
	
	func makeBody(configuration: Self.Configuration) -> some View {
		return configuration.label
			.padding([.top, .bottom], 4)
			.padding([.leading, .trailing])
			.background(background.opacity(0.5))
			.foregroundColor(foreground)
			.clipShape(Capsule())
			.opacity(configuration.isPressed ? 0.7 : 1)
			.scaleEffect(configuration.isPressed ? 0.8 : 1)
			.animation(.easeInOut(duration: 0.2), value: 1)
	}
}


struct Comment_UI: View {
	var data: Comment?
	
	var designMode: Bool?
	
	var delegate: CommentDelegate?
	
	@ObservedObject private var ui = UIRefresher()
	
	@State private var currentText = ""
	
	private var isEditing: Bool {
		get {
			if let delegate = delegate {
				return delegate.isEditing(comment: data)
			}
			return false
		}
	}
	
	private var isNew: Bool { data == nil }
	
	func replies() -> [Comment] {
		let ret = data?.replies?.allObjects.map {$0 as! Comment} ?? []
		return ret.sorted(by: {$0.createdTS > $1.createdTS})
	}
	
	private var numberOfReplies : String {
		get {
			if data?.replies?.count == 1 {
				return "1 reply"
			}
			else {
				return "\(data?.replies?.count ?? 0) replies"
			}
		}
	}
	
	@State private var deleteItem: Bool = false
	
    var body: some View {
		VStack(alignment: .leading) {
			if data?.parentComment == nil {
				Text("Comments")
					.font(.title3).bold()
					.padding(.bottom)
			}
			if let data = data {
				HStack(alignment: .center) {
					Text(data.createdTS.formatted(.dateTime)).bold() +
					Text(" by ") +
					Text(data.authorName ?? "").bold() +
					Text(" (\(numberOfReplies))")
					Spacer()
					
				}
				Divider()
					.padding([.bottom])
				if isEditing {
					VStack(alignment: .leading) {
						TextEditor(text: $currentText)
							.frame(minHeight: 200)
						HStack(spacing: 8) {
							Spacer()
							Button(role: .none) {
								data.text = currentText
								//OK
								delegate?.saveComment(comment: data)
								ui.request()
							} label: {
								Text("Save")
							}
							.buttonStyle(StandardButton())
							Button(role: .cancel) {
								//Cancel
								delegate?.cancelComment(comment: data)
								ui.request()
							} label: {
								Text("Cancel")
							}
							.buttonStyle(StandardButton())
						}
					}
				}
				else {
					Text((designMode ?? false) ? "This is my comment" : (data.text ?? "Some text")).italic().padding(.leading)
					HStack(spacing: 48) {
						Button {
							//TODO: Add comment
							if let parentComment = self.data {
								delegate?.addNewComment(parentComment: parentComment)
							}
							ui.request()
						} label: {
							Text("Reply")
						}
						.disabled(isNew)
						.buttonStyle(StandardButton(background: .blue))
						
						if ((data.author?.isCurrentUserOrAdmin()) != nil) {
							///Edit
							Button {
								currentText = data.text ?? ""
								delegate?.editComment(comment: data)
								ui.request()
							} label: {
								Text("Edit")
							}
							.buttonStyle(StandardButton(background: .green))
							Button(role: .destructive) {
								//TODO: Trash comment
								deleteItem = true
								//delegate?.deleteComment(comment: data)
							} label: {
								Text("Delete")
							}
							.buttonStyle(StandardButton(background: .red))
							.confirmationDialog("Are you sure you want to remove this comment?", isPresented: $deleteItem) {
								Button {
									delegate?.removeComment(comment: data)
								} label: {
									Text("Delete")
								}
								Button(role: .cancel) {
									
								} label: {
									Text("Cancel")
								}
							}
						}
					}
					.disabled(delegate?.isEditingSomething() ?? isEditing)
					.padding([.top, .leading])
				}
				ForEach(replies()) { reply in
					Comment_UI(data: reply, designMode: designMode, delegate: delegate).padding(.leading)
				}
			}
			else {
				Text("No comments").italic()
				Group {
					Button {
						if let parentComment = self.data {
							delegate?.addNewComment(parentComment: parentComment)
						}
						ui.request()
					} label: {
						Text("Add new comment")
					}
					.buttonStyle(StandardButton())
				}
				.disabled(isEditing || delegate == nil)
			}
		}
    }
}

struct Comment_UI_Previews: PreviewProvider {
	static var delegate = CommentHandler()
	static var comment: Comment? {
		get {
			return Comment.getAll().first ?? Comment.create()
		}
	}
    static var previews: some View {
		Comment_UI(data: comment, designMode: true, delegate: delegate)
			.padding()
    }
}

extension Date {
	func getFormatted() -> String {
		return self.formatted()
	}
}
