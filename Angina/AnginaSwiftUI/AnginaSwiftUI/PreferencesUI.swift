//
//  PreferencesUI.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 15/12/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import SwiftUI

struct PreferencesUI: View {

	@State var data : PreferenceData

    var body: some View {
		
		VStack(alignment: .leading) {
			PreferencesTitleUI()
			
			SyncSecurityUI(data: $data.synchronisation)
			ViewPreferencesUI(data: $data.viewPreferences)
			DistanceOptionsUI(data: $data.distanceOptions)
			SearchOptions(data: $data.searchOptions)
			Spacer()
		}
		.padding(.all, 16)
    }
}

struct PreferenceData {
	var synchronisation : SynchronisationData
	
	struct SynchronisationData {
		var syncOnSignOut = false
		var signOutOnScreenOff = false
	}
	
	var viewPreferences : ViewPreferenceData
	
	struct ViewPreferenceData {
		var showCompletedItems = true, includeCompletedItemsInCount = true
		var splitBatchCount = ""
	}
	
	var distanceOptions : DistanceOptionData
	
	struct DistanceOptionData {
		enum DistanceEnum {
			case meters
			case kilometers
			case miles
		}
		
		var farMeasurement = DistanceEnum.kilometers
		var nearMeasurement = DistanceEnum.meters
	}
	
	var searchOptions : SearchOptionData
	
	struct SearchOptionData {
		var searchFullItemText = false
	}
}

struct PreferencesUI_Previews: PreviewProvider {
	
	static var data = PreferenceData(synchronisation: PreferenceData.SynchronisationData(syncOnSignOut: false, signOutOnScreenOff: false), viewPreferences: PreferenceData.ViewPreferenceData(showCompletedItems: true, includeCompletedItemsInCount: true, splitBatchCount: "10"), distanceOptions: PreferenceData.DistanceOptionData(farMeasurement: PreferenceData.DistanceOptionData.DistanceEnum.kilometers, nearMeasurement: PreferenceData.DistanceOptionData.DistanceEnum.meters), searchOptions: PreferenceData.SearchOptionData(searchFullItemText: true))
	
    static var previews: some View {
		PreferencesUI(data: data)
    }
}

struct PreferencesTitleUI: View {
	
	var body: some View {
		Text("Mobile Canvasser Preferences")
			.font(.system(.headline))
			.bold()
		Divider()
//		Image("")
//			.resizable()
//			.background(Color.black)
//			.frame(width: .infinity, height: 1, alignment: .center)
	}
}

struct SyncSecurityUI: View {

	@Binding var data : PreferenceData.SynchronisationData
	
	var body: some View {
		Text("SYNCHRONISATION and SECURITY")
			.padding(.top, 24)
		Toggle("Synchronise on sign out", isOn: $data.syncOnSignOut)
			.padding([.leading], 64)
			.padding([.trailing], 32)
		Toggle("Sign out when device screen turns off", isOn: $data.signOutOnScreenOff)
			.padding([.leading], 64)
			.padding([.trailing], 32)
	}
}

struct ViewPreferencesUI: View {
	
	@Binding var data: PreferenceData.ViewPreferenceData

	var body: some View {
		Text("VIEW PREFERENCES")
			.padding(.top, 24)
		Toggle("Show completed items", isOn: $data.showCompletedItems)
			.padding([.leading], 64)
			.padding([.trailing], 32)
		Toggle("Include completed items as part of collection count", isOn: $data.includeCompletedItemsInCount)
			.padding([.leading], 64)
			.padding([.trailing], 32)
		HStack {
			Text("Automatic split batch count (leave blank for no splits)")
			Spacer()
			TextField("", text: $data.splitBatchCount)
				.multilineTextAlignment(.trailing)
				.frame(width: 100, height: 48, alignment: .trailing)
				.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 4)
				.border(Color.black, width: 1)
				.keyboardType(.numberPad)
		}
		.padding([.leading], 64)
		.padding([.trailing], 32)
	}
}

struct DistanceOptionsUI: View {
	
	@Binding var data : PreferenceData.DistanceOptionData

	var body: some View {
		Text("DISTANCE OPTIONS")
			.padding(.top, 24)

		Text("Far measurement")
			.padding(.top, 24)
			.padding(.leading, 64)
		Picker(selection: $data.farMeasurement, label: Text("Far measurement")) {
			Text("Kilometre").tag(PreferenceData.DistanceOptionData.DistanceEnum.kilometers)
			Text("Metre").tag(PreferenceData.DistanceOptionData.DistanceEnum.meters)
			Text("Mile").tag(PreferenceData.DistanceOptionData.DistanceEnum.miles)
		}
		.frame(width: .infinity, height: 100, alignment: .center)
		.padding([.leading, .trailing], 64)

		Text("Near measurement")
			.padding(.top, 24)
			.padding(.leading, 64)
		Picker(selection: $data.nearMeasurement, label: Text("Near measurement")) {
			Text("Kilometre").tag(PreferenceData.DistanceOptionData.DistanceEnum.kilometers)
			Text("Metre").tag(PreferenceData.DistanceOptionData.DistanceEnum.meters)
			Text("Mile").tag(PreferenceData.DistanceOptionData.DistanceEnum.miles)
		}
		.frame(width: .infinity, height: 100, alignment: .center)
		.padding([.leading, .trailing], 64)
	}
}

struct SearchOptions: View {
	
	@Binding var data : PreferenceData.SearchOptionData
	
	var body: some View {
		Text("SEARCH OPTIONS")
			.padding(.top, 24)
		Toggle("Search full item text", isOn: $data.searchFullItemText)
			.padding([.leading], 64)
			.padding([.trailing], 32)
	}
}
