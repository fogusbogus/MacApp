//
//  Measuring.swift
//  FBTodo
//
//  Created by Matt Hogg on 16/03/2022.
//

import Foundation
import SwiftUI


final class MeasuringView : ObservableObject {
	
	private var values: [String:CGSize] = [:]
	
	@Published var update: Bool = false
	
	subscript(index: String) -> CGSize {
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
			return CGSize.zero
		}
		set(newValue) {
			let index = index.lowercased()
			values[index] = newValue
		}
	}
	
	private func setSizeWH(index: String, size: CGSize, measuring: MeasurementType = .max) -> Bool {
		let index = measuring.key(index)
		var sz = self[index]
		
		var mustUpdate = false
		if measuring == .max {
			if sz.width < size.width {
				sz.width = size.width
				print("\(index) width > \(size.width)")
				mustUpdate = true
			}
			if sz.height < size.height {
				sz.height = size.height
				print("\(index) height > \(size.height)")
				mustUpdate = true
			}
		}
		else {
			if sz.width > size.width {
				sz.width = size.width
				print("\(index) width < \(size.width)")
				mustUpdate = true
			}
			if sz.height > size.height {
				sz.height = size.height
				print("\(index) height < \(size.height)")
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
	
	enum MeasurementType {
		case max, min
		
		func key(_ key: String) -> String {
			return key + (self == .max ? ".max" : ".min")
		}
	}
}

extension View {
	
	func decidesHeightOf(_ heightClass: MeasuringView, key: String, alignment: Alignment = .center, measuring: MeasuringView.MeasurementType = .max) -> some View {
		switch measuring {
			case .max:
				return self.frame(minHeight: heightClass[measuring.key(key)].height, alignment:alignment).measure(setValue: heightClass.setSize, index: key)
			case .min:
				return self.frame(maxHeight: heightClass[measuring.key(key)].height, alignment:alignment).measure(setValue: heightClass.setSize, index: key)
		}
		
	}
	func decidesWidthOf(_ widthClass: MeasuringView, key: String, alignment: Alignment = .center, measuring: MeasuringView.MeasurementType = .max) -> some View {
		switch measuring {
			case .max:
				return self.frame(minWidth: widthClass[measuring.key(key)].width, alignment:alignment).measure(setValue: widthClass.setSize, index: key)
			case .min:
				return self.frame(maxWidth: widthClass[measuring.key(key)].width, alignment:alignment).measure(setValue: widthClass.setSize, index: key)
		}
		
	}
	func followsHeightOf(_ heightClass: MeasuringView, key: String, alignment: Alignment = .center, multiplier: CGFloat = 1.0, measuring: MeasuringView.MeasurementType = .max) -> some View {
		return self.frame(height: heightClass[measuring.key(key)].height * multiplier, alignment: alignment)
	}
	func followsWidthOf(_ widthClass: MeasuringView, key: String, alignment: Alignment = .center, multiplier: CGFloat = 1.0, measuring: MeasuringView.MeasurementType = .max) -> some View {
		return self.frame(width: widthClass[measuring.key(key)].width * multiplier, alignment: alignment)
	}

	func measure(setValue: @escaping (CGSize) -> Void) -> some View {
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
	
	func measure(setValue: @escaping (String, CGSize) -> Void, index: String) -> some View {
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
