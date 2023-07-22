//
//  Markers.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 29/06/2023.
//

import Foundation
import SwiftUI

struct MarkerView : View {
	
	var marker: Marker
	
	var body: some View {
		Text(marker.symbols)
			//.help(marker.description)
	}
}

enum Marker : Int {
	case none = 0,
		 young = 1,
		 over70 = 2,
		 rising70 = 4,
		 houseHolder = 8,
		 crownServant = 16,
		 lord = 32,
		 service = 64,
		 supplementaryClaim = 128,
		 euroLocal = 0x100,
		 euroLocalAndEuro = 0x200,
		 euroPending = 0x400,
		 homeless = 0x800,
		 remand = 0x1000,
		 overseas = 0x2000,
		 overseasLord = 0x4000,
		 deceased = 0x8000,
		 mentalHealthPatient = 0x10000,
		 postalVoter = 0x20000,
		 proxyVoter = 0x40000,
		 new = 0x80000,
		 requestPostalVote = 0x100000,
		 requestProxyVote = 0x200000,
		 omitFromEditedRegister = 0x400000,
		 suppressPollCard = 0x800000,
		 anonymous = 0x1000000
	
	func has(_ values: Self...) -> Bool {
		return values.allSatisfy {self.rawValue & $0.rawValue != 0}
	}
	
	var description: [String] {
		get {
			var ret : [String] = []
			
			if self.has(.young) {
				ret.append("Under 18")
			}
			if self.has(.over70) {
				ret.append("Elderly")
			}
			if self.has(.rising70) {
				ret.append("Pensioner")
			}
			if self.has(.houseHolder) {
				ret.append("Homeowner")
			}
			if self.has(.crownServant) {
				ret.append("Crown Servant")
			}
			if self.has(.lord) {
				ret.append("Lord/Lady")
			}
			if self.has(.service) {
				ret.append("Service Voter")
			}
			if self.has(.supplementaryClaim) {
				ret.append("Supplementary Claim")
			}
			if self.has(.euroLocal) {
				ret.append("Local Only")
			}
			if self.has(.euroLocalAndEuro) {
				ret.append("Euro Elections")
			}
			if self.has(.euroPending) {
				ret.append("Euro TBC")
			}
			if self.has(.homeless) {
				ret.append("Homeless")
			}
			if self.has(.remand) {
				ret.append("Remand Prisoner")
			}
			if self.has(.overseas) {
				ret.append("Overseas Voter")
			}
			if self.has(.overseasLord) {
				ret.append("Overseas Lord/Lady")
			}
			if self.has(.deceased) {
				ret.append("Deceased")
			}
			if self.has(.mentalHealthPatient) {
				ret.append("Vulnerable")
			}
			if self.has(.postalVoter) {
				ret.append("Postal Voter")
			}
			if self.has(.proxyVoter) {
				ret.append("Proxy Voter")
			}
			if self.has(.new) {
				ret.append("New Voter")
			}
			if self.has(.requestPostalVote) {
				ret.append("Postal Vote Requested")
			}
			if self.has(.requestProxyVote) {
				ret.append("Proxy Vote Requested")
			}
			if self.has(.omitFromEditedRegister) {
				ret.append("Omitted from Edited Register")
			}
			if self.has(.suppressPollCard) {
				ret.append("Poll Card Suppressed")
			}
			if self.has(.anonymous) {
				ret.append("Anonymous")
			}
			return ret
		}
	}
	
	var symbols: String {
		get {
			var ret : [String] = []
			
			if self.has(.young) {
				ret.append("🐥")
			}
			if self.has(.over70) {
				ret.append("👵🏽")
			}
			if self.has(.rising70) {
				ret.append("🧓🏻")
			}
			if self.has(.houseHolder) {
				ret.append("🏠")
			}
			if self.has(.crownServant) {
				ret.append("👑")
			}
			if self.has(.lord) {
				ret.append("⚔️")
			}
			if self.has(.service) {
				ret.append("🔫")
			}
			if self.has(.supplementaryClaim) {
				ret.append("🔮")
			}
			if self.has(.euroLocal) {
				ret.append("🇬🇧")
			}
			if self.has(.euroLocalAndEuro) {
				ret.append("🇪🇺")
			}
			if self.has(.euroPending) {
				ret.append("🏴")
			}
			if self.has(.homeless) {
				ret.append("📦")
			}
			if self.has(.remand) {
				ret.append("❌")
			}
			if self.has(.overseas) {
				ret.append("🚣🏻‍♀️")
			}
			if self.has(.overseasLord) {
				ret.append("🛳️")
			}
			if self.has(.deceased) {
				ret.append("😵")
			}
			if self.has(.mentalHealthPatient) {
				ret.append("🥜")
			}
			if self.has(.postalVoter) {
				ret.append("✉️")
			}
			if self.has(.proxyVoter) {
				ret.append("🗳️")
			}
			if self.has(.new) {
				ret.append("🆕")
			}
			if self.has(.requestPostalVote) {
				ret.append("💌")
			}
			if self.has(.requestProxyVote) {
				ret.append("💙")
			}
			if self.has(.omitFromEditedRegister) {
				ret.append("❎")
			}
			if self.has(.suppressPollCard) {
				ret.append("🗂️")
			}
			if self.has(.anonymous) {
				ret.append("❓")
			}
			return ret.joined(separator: "")
		}
	}
	
}
