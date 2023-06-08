//
//  Measuring.swift
//  FBTodo
//
//  Created by Matt Hogg on 16/03/2022. Please update.
//

import Foundation
import SwiftUI


@available(iOS 13.0, *)
@available(macOS 10.15, *)
/// Measure and align other views to my size
public final class MeasuringView : ObservableObject {
	public init(values: [String : CGSize] = [:], update: Bool = false, delegate: MeasuringViewLogging? = nil) {
		self.values = values
		self.update = update
		self.delegate = delegate
	}
	
	private var values: [String:CGSize] = [:]
	
	@Published var update: Bool = false
	
	public var delegate: MeasuringViewLogging? = nil
	
	public subscript(index: String) -> CGSize {
		get {
			let index = index.lowercased()
			if values.keys.contains(index) {
				return values[index]!
			}
			if index.contains("+") {
				let indices = index.split(separator: "+")
				var ret = CGSize.zero
				indices.forEach { ss in
					let sz = self[index]
					ret = CGSize(width: ret.width + sz.width, height: ret.height + sz.height)
				}
				return ret
			}
			values[index] = CGSize()
			return CGSize.zero
		}
		set(newValue) {
			let index = index.lowercased()
			values[index] = newValue
			delegate?.log("D", "[\(index)] <- \(newValue)")
		}
	}
	
	/// Reset a key to a blank size
	/// - Parameter key: The key of the item
	public func reset(key: String) {
		delegate?.log("F", "reset(key: \"\(key)\")")
		values[key.lowercased()] = CGSize()
	}
	
	public func dump(forKey: String = "") -> String {
		delegate?.log("D", "dump(forKey: \"\(forKey)\")")
		guard values.count > 0 else { return "" }
		var items: [String:CGSize] = [:]
		if forKey.lengthOfBytes(using: .utf8) > 0 {
			///We want to filter
			values.filter {$0.key.lowercased().contains(forKey.lowercased())}.forEach {items[$0.key] = $0.value}
		}
		else {
			values.forEach {items[$0.key] = $0.value}
		}
		let maxLength = items.keys.map {$0.lengthOfBytes(using: .utf8)}.max() ?? 0
		return items.map { kv in
			var (key, value) = kv
			key = key + String(repeating: " ", count: maxLength).left(maxLength)
			return "\(key) -> w: \(value.width), h: \(value.height)"
		}.joined(separator: "\n")
	}
	
	/// Get the measurement
	/// - Parameters:
	///   - index: The key of the measurement
	///   - measuring: constraint of measurement
	/// - Returns: CGSize representation
	public func `get`(_ index: String, measuring: MeasurementType = .max) -> CGSize? {
		return values[measuring.key(index).lowercased()]
	}
	
	private func setSizeWH(index: String, size: CGSize, measuring: MeasurementType = .max) -> Bool {
		delegate?.log("F", "setSizeWH(index: \"\(index)\", size: (\(size.width),\(size.height)), measuring: \(measuring)")
		let index = measuring.key(index)
		var sz = self[index]
		
		var mustUpdate = false
		if measuring == .max {
			if sz.width < size.width {
				sz.width = size.width
				delegate?.log("D", "\(index) width > \(size.width)")
				mustUpdate = true
			}
			if sz.height < size.height {
				sz.height = size.height
				delegate?.log("D", "\(index) height > \(size.height)")
				mustUpdate = true
			}
		}
		else {
			if sz.width > size.width {
				sz.width = size.width
				delegate?.log("D", "\(index) width < \(size.width)")
				mustUpdate = true
			}
			if sz.height > size.height {
				sz.height = size.height
				delegate?.log("D", "\(index) height < \(size.height)")
				mustUpdate = true
			}
		}
		self[index] = sz
		return mustUpdate
	}
	
	func setSize(index: String, size: CGSize) {
		let mustUpdate = setSizeWH(index: index, size: size, measuring: .max) || setSizeWH(index: index, size: size, measuring: .min)
		if mustUpdate {
			update = !update
		}
	}
	
	/// Measurement constraint - limited to minimum and maximum
	public enum MeasurementType {
		case max, min
		
		func key(_ key: String) -> String {
			return key + (self == .max ? ".max" : ".min")
		}
	}
	
}


public protocol MeasuringViewLogging {
	func log(_ type: String, _ message: String)
}

private extension String {
	func substring(from: Int, to: Int) -> String {
		guard from < self.lengthOfBytes(using: .utf8) else { return "" }
		guard to >= 0 && from >= 0 && from <= to else {
			return ""
		}
		
		let start = index(startIndex, offsetBy: from)
		var toIndex = self.lengthOfBytes(using: .utf8) - 1
		if  to < toIndex {
			toIndex = to
		}
		let end = index(startIndex, offsetBy: toIndex)
		return String(self[start ... end])
	}
	
	func left(_ maxLen: Int) -> String {
		return self.substring(from: 0, to: maxLen - 1)
	}
}

public extension View {
	
	/// This view decides the height constraints for a given key. Use followsHeightOf if you want it to follow another view's height.
	/// - Parameters:
	///   - heightClass: MeasuringView type. Declare as @ObservedObject private var.
	///   - key: Key
	///   - alignment: Ultimately the frame is affected, but allow access to the alignment.
	///   - measuring: Measurement constraint.
	/// - Returns: some View
	func decidesHeightOf(_ heightClass: MeasuringView, key: String, alignment: Alignment = .center, measuring: MeasuringView.MeasurementType = .max) -> some View {
		switch measuring {
			case .max:
				return self.frame(minHeight: heightClass[measuring.key(key)].height, alignment:alignment).measure(setValue: heightClass.setSize, index: key)
			case .min:
				return self.frame(maxHeight: heightClass[measuring.key(key)].height, alignment:alignment).measure(setValue: heightClass.setSize, index: key)
		}
		
	}
	/// This view decides the height constraints for a given key. Use followsWidthOf if you want it to follow another view's width.
	/// - Parameters:
	///   - widthClass: MeasuringView type. Declare as @ObservedObject private var.
	///   - key: Key
	///   - alignment: Ultimately the frame is affected, but allow access to the alignment.
	///   - measuring: Measurement constraint
	/// - Returns: some View
	func decidesWidthOf(_ widthClass: MeasuringView, key: String, alignment: Alignment = .center, measuring: MeasuringView.MeasurementType = .max) -> some View {
		switch measuring {
			case .max:
				return self.frame(minWidth: widthClass[measuring.key(key)].width, alignment:alignment).measure(setValue: widthClass.setSize, index: key)
			case .min:
				return self.frame(maxWidth: widthClass[measuring.key(key)].width, alignment:alignment).measure(setValue: widthClass.setSize, index: key)
		}
		
	}
	/// This view follows a height constraint. Use decidesHeightOf if you want it to control the height of another view.
	/// - Parameters:
	///   - heightClass: MeasuringView type. Declare as @ObservedObject private var.
	///   - key: Key
	///   - alignment: Ultimately the frame is affected, but allow access to the alignment
	///   - multiplier: As we are following another view's measurement we might want the value to be a portion.
	///   - measuring: Measurement constraint.
	/// - Returns: some View
	func followsHeightOf(_ heightClass: MeasuringView, key: String, alignment: Alignment = .center, multiplier: CGFloat = 1.0, measuring: MeasuringView.MeasurementType = .max) -> some View {
		return self.frame(height: heightClass[measuring.key(key)].height * multiplier, alignment: alignment)
	}
	/// This view follows a width constraint. Use decidesWidthOf if you want it to control the width of another view.
	/// - Parameters:
	///   - widthClass: MeasuringView type. Declare as @ObservedObject private var.
	///   - key: Key
	///   - alignment: Ultimately the frame is affected, but allow access to the alignment
	///   - multiplier: As we are following another view's measurement we might want the value to be a portion.
	///   - measuring: Measurement constraint.
	/// - Returns: some View
	func followsWidthOf(_ widthClass: MeasuringView, key: String, alignment: Alignment = .center, multiplier: CGFloat = 1.0, measuring: MeasuringView.MeasurementType = .max) -> some View {
		return self.frame(width: widthClass[measuring.key(key)].width * multiplier, alignment: alignment)
	}
	
	/// Allows us to offset the view by a fractional amount of some other view's height
	/// - Parameters:
	///   - heightClass: MeasuringView type. Declare as @ObservedObject private var.
	///   - key: Key
	///   - multiplier: As we are following another view's measurement we might want the value to be a portion.
	///   - measuring: Measurement constraint.
	/// - Returns: some View
	func offsetByHeight(_ heightClass: MeasuringView, key: String, multiplier: CGFloat = 1.0, measuring: MeasuringView.MeasurementType = .max) -> some View {
		return self.offset(y: heightClass[measuring.key(key)].height * multiplier)
	}
	/// Allows us to offset the view by a fractional amount of some other view's width
	/// - Parameters:
	///   - widthClass: MeasuringView type. Declare as @ObservedObject private var.
	///   - key: Key
	///   - multiplier: As we are following another view's measurement we might want the value to be a portion.
	///   - measuring: Measurement constraint.
	/// - Returns: some View
	func offsetByWidth(_ widthClass: MeasuringView, key: String, multiplier: CGFloat = 1.0, measuring: MeasuringView.MeasurementType = .max) -> some View {
		return self.offset(x: widthClass[measuring.key(key)].width * multiplier)
	}
	
	private func measure(setValue: @escaping (CGSize) -> Void) -> some View {
		let ret = self.background(
			GeometryReader { fooProxy in
				Color
					.clear
					.preference(key: MeasureSizePreferenceKey.self,
								value: fooProxy.size)
					.onPreferenceChange(MeasureSizePreferenceKey.self) { size in
						setValue(size)
					}
			}
		)
		return ret
	}
	
	private func measure(setValue: @escaping (String, CGSize) -> Void, index: String) -> some View {
		let ret = self.background(
			GeometryReader { fooProxy in
				Color
					.clear
					.preference(key: MeasureSizePreferenceKey.self,
								value: fooProxy.size)
					.onPreferenceChange(MeasureSizePreferenceKey.self) { size in
						setValue(index, size)
					}
			}
		)
		return ret
	}
	
}

private struct MeasureSizePreferenceKey: PreferenceKey {
	static let defaultValue = CGSize.zero
	static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
		value = nextValue()
	}
}
