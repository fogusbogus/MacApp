//
//  Board+UI.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 23/07/2023.
//

import Foundation
import SwiftUI

struct Board_UI: View {
	
	struct Options {
		var laneSpacing: CGFloat = 24
		var laneWidth: CGFloat = 500
		
		var laneOptions: Lane_UI.Options = Lane_UI.Options()
	}
	
	var lanes: [Lane]
	
	var options = Options()
	
	@State private var targetedLane : Lane?
	
	@ObservedObject var uiUpdater = UIRefresher()
	
	var body: some View {
		ScrollView(.horizontal) {
			HStack(alignment: .top, spacing: options.laneSpacing) {
				ForEach(lanes, id:\.self) { lane in
					Lane_UI(lane: lane, delegate: self, options: options.laneOptions)
						.frame(width: options.laneWidth)
				}
			}
		}
	}
}

extension Board_UI : LaneRefreshRequest {
	func laneRequiresRefresh(lane: Lane) {
		uiUpdater.request()
	}
	
	
}

struct Board_UI_Previews: PreviewProvider {
	static var lanes: [Lane] {
		get {
			PersistenceController.shared.seed()
			return Lane.getAll().sorted(by: {$0.order < $1.order})
		}
	}
	static var previews: some View {
		Board_UI(lanes: lanes)
			
	}
}

