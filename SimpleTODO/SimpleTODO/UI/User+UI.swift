//
//  User+UI.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 22/07/2023.
//

import SwiftUI

struct User_UI: View {
	
	struct Options {
		var backgroundColor: Color?
		var foregroundColor: Color?
		var size: CGFloat = 56
		var font: Font = .title
	}
	
	var user: User?
	var options = Options()
	
	private var iconImage: Image? {
		get {
			if let icon = user?.icon {
				#if os(iOS)
				if let uiImage = UIImage(data: icon) {
					return Image(uiImage: uiImage)
				}
				#else
				if let img = NSImage(data: icon) {
					return Image(nsImage: img)
				}
				#endif
			}
			return nil
		}
	}
	
	private func initials() -> String {
		if let user = user {
			return user.name!.split { $0 == " " }.filter {!$0.isEmpty}.map {$0.prefix(1)}.joined().uppercased()
		}
		return ""
	}
    var body: some View {
        ZStack {
			if let _ = user {
				Circle()
					.frame(width: options.size, height: options.size)
					.foregroundColor(options.backgroundColor ?? .blue)
				
				// Some users prefer an image
				if let image = iconImage {
					image
						.resizable(resizingMode: .stretch)
						.frame(width: options.size, height: options.size)
						.cornerRadius(options.size / 2)
				}
				else {
					Text(initials())
						.foregroundColor(options.foregroundColor ?? .white)
						.font(options.font)
						.bold()
				}
			}
			else {
				EmptyView()
			}
        }
    }
}

struct User_UI_Previews: PreviewProvider {
	static var user: User {
		get {
			return User.admin()
		}
	}
    static var previews: some View {
		User_UI(user: user)
    }
}
