//
//  ContentView.swift
//  MCResults
//
//  Created by Matt Hogg on 09/01/2023.
//

import SwiftUI

struct ContentView: View {
	func getData() -> SummaryItems {
		return SummaryItems(antiSpoof: SummaryItemsAntiSpoofing(dmarc: .good, spf: .good, dkim: .unknown), emailPrivacy: SummaryItemsEmailPrivacy(tls: .good, mtaSts: .bad))
		
	}
    var body: some View {
		SummaryResult(data: getData())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Styling()
    }
}
