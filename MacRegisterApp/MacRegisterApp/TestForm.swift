//
//  TestForm.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 06/06/2023.
//

import SwiftUI

struct TestForm: View {
	
	@State var username = ""
	@State var password = ""
	@State var street = ""
	@State var city = ""
	@State var zipCode = ""
	
	var body: some View {
		Form {
			Section(header: Text("Account Information").font(.title)) {
				TextField("Username", text: $username)
				SecureField("Password", text: $password)
			}
			
			Section(header: Text("Address").font(.title)) {
				TextField("Street", text: $street)
				TextField("City", text: $city)
				TextField("Zip code", text: $zipCode)
			}
		}
		.background(Color.clear)
		.padding()
	}
}

struct TestForm_Previews: PreviewProvider {
    static var previews: some View {
        TestForm()
    }
}
