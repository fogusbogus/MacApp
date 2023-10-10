//
//  DataEntry.ITR.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 22/12/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import SwiftUI

class ITRData : ObservableObject {

	init() {
	}
	
	var Title : String = "" {
		didSet {
			update.toggle()
		}
	}
	var Forename : String = "" {
		didSet {
			update.toggle()
		}
	}
	var Middle : String = "" {
		didSet {
			update.toggle()
		}
	}
	var Surname : String = "" {
		didSet {
			update.toggle()
		}
	}
	var NINO : String = "" {
		didSet {
			update.toggle()
		}
	}
	var Email : String = "" {
		didSet {
			update.toggle()
		}
	}
	var Phone : String = "" {
		didSet {
			update.toggle()
		}
	}
	var DOB : Date = Date() {
		didSet {
			update.toggle()
		}
	}
	var Single : Bool = false {
		didSet {
			update.toggle()
		}
	}
	
	var valid_Title : Bool {
		get {
			return !Title.isEmptyOrWhitespace()
		}

	}
	
	var valid_Forename : Bool {
		get {
			return !Forename.isEmptyOrWhitespace()
		}
	}
	
	var valid_Middle : Bool {
		get {
			return true
		}
	}
	
	var valid_Surname : Bool {
		get {
			return !Surname.isEmptyOrWhitespace()
		}
	}
	
	var valid_NINO : Bool {
		get {
			return NINO.isEmptyOrWhitespace() || NINO.isValidNINO()
		}
	}
	
	var valid_Email : Bool {
		get {
			return Email.isEmptyOrWhitespace() || Email.isValidEmail()
		}
	}

	var valid_Phone : Bool {
		get {
			return Phone.isEmptyOrWhitespace() || Phone.isValidUKPhoneNo()
		}
	}
	
	var valid_DOB : Bool {
		get {
			return DOB.addYears(16) <= Date()
		}
	}
	
	@Published
	var update : Bool = false

}


struct DataEntry_ITR: View {
	
	@ObservedObject var data : ITRData
	
    var body: some View {
		VStack(alignment: .leading, spacing: 16, content: {
			VStack {	//NAME
				DataEntry_TextItem(Value: $data.Title, Placeholder: "Title (Optional)", validator: data.valid_Title, keyboardType: .namePhonePad)
				
				DataEntry_TextItem(Value: $data.Forename, Placeholder: "First name", validator: data.valid_Forename, keyboardType: .namePhonePad)
				DataEntry_TextItem(Value: $data.Middle, Placeholder: "Middle name", validator: data.valid_Middle, keyboardType: .namePhonePad)
				DataEntry_TextItem(Value: $data.Surname, Placeholder: "Surname", validator: data.valid_Surname, keyboardType: .namePhonePad)
			}
			VStack {	//AGE
				DataEntry_ToggleItem(Value: $data.Single, Placeholder: "Are you the only person aged 16 or over living at this address? (Optional)")
				
				DataEntry_DateItem(Value: $data.DOB, Placeholder: "Date of birth", validator: data.valid_DOB)
			}
			
			VStack {	//QUICK IDENTIFIERS
				DataEntry_SecureItem(Value: $data.NINO, Placeholder: "National Insurance Number", validator: data.valid_NINO)
				DataEntry_TextItem(Value: $data.Email, Placeholder: "Email address", validator: data.valid_Email, keyboardType: .emailAddress)
				DataEntry_TextItem(Value: $data.Phone, Placeholder: "Phone number", validator: data.valid_Phone, keyboardType: .phonePad)
			}
		})
		.padding([.leading, .trailing], 24)
    }
}

private extension String {
	func isValidEmail() -> Bool {
		// here, `try!` will always succeed because the pattern is valid
		let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
		return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
	}
	
	func isValidNINO() -> Bool {
		let regex = try! NSRegularExpression(pattern: "^[A-CEGHJ-NPR-TW-Za-ceghj-pr-tw-z]{1}[A-CEGHJ-NPR-TW-Za-ceghj-npr-tw-z]{1}[0-9]{6}[A-DFMa-dfm]{1}$", options: .caseInsensitive)
		return regex.firstMatch(in: self.replacingOccurrences(of: " ", with: ""), options: [], range: NSRange(location: 0, length: count)) != nil
	}
	
	func isValidUKPhoneNo() -> Bool {
//		let regex = try! NSRegularExpression(pattern: "^(((\+44\s?\d{4}|\(?0\d{4}\)?)\s?\d{3}\s?\d{3})|((\+44\s?\d{3}|\(?0\d{3}\)?)\s?\d{3}\s?\d{4})|((\+44\s?\d{2}|\(?0\d{2}\)?)\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$", options: .caseInsensitive)
//		return regex.firstMatch(in: self.replacingOccurrences(of: " ", with: ""), options: [], range: NSRange(location: 0, length: count)) != nil
		return true
	}
}

struct DataEntry_ITR_Previews: PreviewProvider {
	
	@State static var data : ITRData =
		ITRData()
	
    static var previews: some View {
		DataEntry_ITR(data: data)
    }
}

struct DataEntry_TextItem: View {
	
	@Binding var Value : String
	var Placeholder = ""
	
	var validator : Bool
	
	var keyboardType: UIKeyboardType = .default
	
	var body: some View {
			HStack(alignment: .center, spacing: 16) {
				if validator {
					Image(systemName: "")
						.resizable()
						.frame(width: 24, height: 24, alignment: .center)
						.foregroundColor(.red)
				}
				else {
					Image(systemName: "exclamationmark.triangle.fill")
						.resizable()
						.frame(width: 24, height: 24, alignment: .center)
						.foregroundColor(.red)
				}
				ZStack {
					TextField(Placeholder, text: $Value)
						.keyboardType(keyboardType)
					VStack {
						Divider()
							.offset(x: 0, y: 14)
					}
				}
			}
		
	}
}

struct DataEntry_SecureItem: View {
	
	@Binding var Value : String
	var Placeholder = ""
	
	var validator : Bool
	
	var body: some View {
		HStack(alignment: .center, spacing: 16) {
			if validator {
				Image(systemName: "")
					.resizable()
					.frame(width: 24, height: 24, alignment: .center)
					.foregroundColor(.red)
			}
			else {
				Image(systemName: "exclamationmark.triangle.fill")
					.resizable()
					.frame(width: 24, height: 24, alignment: .center)
					.foregroundColor(.red)
			}
			ZStack {
				SecureField(Placeholder, text: $Value)
				VStack {
					Divider()
						.offset(x: 0, y: 14)
				}
			}
		}
		
	}
}

struct DataEntry_ToggleItem: View {
	
	@Binding var Value : Bool
	var Placeholder = ""
	
	var body: some View {
		HStack(alignment: .center, spacing: 16) {
			Image(systemName: "")
				.resizable()
				.frame(width: 24, height: 24, alignment: .center)
				.foregroundColor(.red)
			Toggle(Placeholder, isOn: $Value)
		}
		
	}
}

struct DataEntry_DateItem: View {
	
	@Binding var Value : Date
	var Placeholder = ""
	
	var validator : Bool
	
	var body: some View {
		HStack(alignment: .center, spacing: 16) {
			if validator {
				Image(systemName: "")
					.resizable()
					.frame(width: 24, height: 24, alignment: .center)
					.foregroundColor(.red)
			}
			else {
				Image(systemName: "exclamationmark.triangle.fill")
					.resizable()
					.frame(width: 24, height: 24, alignment: .center)
					.foregroundColor(.red)
			}
			ZStack {
				DatePicker(Placeholder, selection: $Value, displayedComponents: .date)
				VStack {
					Divider()
						.offset(x: 0, y: 14)
				}
			}
		}
		
	}
}
