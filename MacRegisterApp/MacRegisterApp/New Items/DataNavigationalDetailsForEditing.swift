//
//  DataNavigationalDetailsForEditing.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 14/06/2023.
//

import Foundation

class DataNavigationalDetailsForEditing<T: DataNavigational> : ObservableObject {
	convenience init(object: T?) {
		self.init()
		self.object = object
		self.copyObject(object: object)
	}
	
	func load(object: T?) {
		copyObject(object: object)
	}
	
	/// Override this function to setup the data from the object
	/// - Parameter object: The object we are copying
	func copyObject(object: T?) {
		
	}
	
	@Published var object: T?
	
	/// Override this
	func canSave(withParent: DataNavigational?) -> Bool { errors(parent: nil).count == 0 }
	
	/// Override this - copies the inside object to an outside object
	/// - Parameter object: Object to copy to
	func copyToObject(_ object: T?) {
		
	}
	
	/// Override this
	func reset() {
		
	}
	
	func errors(parent: DataNavigational?) -> [Error] {
		return []
	}
}
