//
//  General+Extensions.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 29/07/2023.
//

import Foundation
import SwiftUI


extension CGColor {
	public static func fromHex(_ hex: String?, alpha: Double = 1.0) -> CGColor {
		guard let hex = hex else { return ColorHelper.clear }
		let r, g, b, a: CGFloat
		
		if hex.hasPrefix("#") {
			let start = hex.index(hex.startIndex, offsetBy: 1)
			let hexColor = String(hex[start...])
			
			if hexColor.count == 8 {
				let scanner = Scanner(string: hexColor)
				var hexNumber: UInt64 = 0
				
				if scanner.scanHexInt64(&hexNumber) {
					r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
					g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
					b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
					a = CGFloat(hexNumber & 0x000000ff) / 255
					
					return CGColor(red: r, green: g, blue: b, alpha: a)
				}
			}
			if hexColor.count == 6 {
				let scanner = Scanner(string: hexColor)
				var hexNumber: UInt64 = 0
				
				if scanner.scanHexInt64(&hexNumber) {
					r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
					g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
					b = CGFloat(hexNumber & 0x000000ff) / 255
					
					return CGColor(red: r, green: g, blue: b, alpha: alpha)
				}
			}
		}
		
		return ColorHelper.clear
	}
	
	public var hexString: String {
		get {
			guard numberOfComponents > 0 else { return "" }
			return components!.map {String(format: "%02x", Int($0 * 255.0))}.joined()
		}
	}
}

extension String {
	func removeMultipleSpaces() -> String {
		var ret = self
		while ret.contains(/\ {2,}/) {
			ret = ret.replacing(/\ {2,}/, with: " ")
		}
		return ret
	}
}

extension View {
	func hidden(_ hide: Bool) -> AnyView {
		if hide {
			return AnyView(self.hidden())
		}
		return AnyView(self)
	}
}

extension Date {
	func getFormatted() -> String {
		return self.formatted()
	}
}


@objc(UIColorValueTransformer)
public final class UIColorValueTransformer: ValueTransformer {
	override public class func transformedValueClass() -> AnyClass {
		return UIColor.self
	}
	
	override public class func allowsReverseTransformation() -> Bool {
		return true
	}
	
	override public func transformedValue(_ value: Any?) -> Any? {
		guard let color = value as? UIColor else { return nil }
		
		do {
			let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true)
			return data
		} catch {
			assertionFailure("Failed to transform `UIColor` to `Data`")
			return nil
		}
	}
	
	override public func reverseTransformedValue(_ value: Any?) -> Any? {
		guard let data = value as? NSData else { return nil }
		
		do {
			let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data as Data)
			return color
		} catch {
			assertionFailure("Failed to transform `Data` to `UIColor`")
			return nil
		}
	}
}


extension UIColorValueTransformer {
	/// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
	static let name = NSValueTransformerName(rawValue: String(describing: UIColorValueTransformer.self))
	
	/// Registers the value transformer with `ValueTransformer`.
	public static func register() {
		let transformer = UIColorValueTransformer()
		ValueTransformer.setValueTransformer(transformer, forName: name)
	}
}


@objc(UIImageValueTransformer)
public final class UIImageValueTransformer: ValueTransformer {
	override public class func transformedValueClass() -> AnyClass {
		return UIImage.self
	}
	
	override public class func allowsReverseTransformation() -> Bool {
		return true
	}
	
	override public func transformedValue(_ value: Any?) -> Any? {
		guard let image = value as? UIImage else { return nil }
		
		do {
			let data = try NSKeyedArchiver.archivedData(withRootObject: image, requiringSecureCoding: true)
			return data
		} catch {
			assertionFailure("Failed to transform `UIImage` to `Data`")
			return nil
		}
	}
	
	override public func reverseTransformedValue(_ value: Any?) -> Any? {
		guard let data = value as? NSData else { return nil }
		
		do {
			let image = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIImage.self, from: data as Data)
			return image
		} catch {
			assertionFailure("Failed to transform `Data` to `UIImage`")
			return nil
		}
	}
}


extension UIImageValueTransformer {
	/// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
	static let name = NSValueTransformerName(rawValue: String(describing: UIImageValueTransformer.self))
	
	/// Registers the value transformer with `ValueTransformer`.
	public static func register() {
		let transformer = UIImageValueTransformer()
		ValueTransformer.setValueTransformer(transformer, forName: name)
	}
}
