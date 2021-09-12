//
//  CanvasserApp.swift
//  Canvasser
//
//  Created by Matt Hogg on 16/01/2021.
//

import SwiftUI

@main
struct CanvasserApp: App {
    //let persistenceController = PersistenceController.shared

	var _data : NavBarData? = nil
	var data : NavBarData {
		get {
			if _data == nil {
				CoreDataManager.shared.setup()
				let ret = NavBarData()
				ret.navigateTo(("ST132", "Berkeley Close"))
				return ret
			}
			return _data!
		}
	}
    var body: some Scene {
        WindowGroup {
			NavBar(clickDelegate: { (nb, action) in
				if action == .back {
					data.goBack()
				}
			}, data: data)
			//ContentView()
                //.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
