//
//  MacRegisterAppApp.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 20/05/2023.
//

import SwiftUI
import TreeView

@main
struct MacRegisterAppApp: App {
	
	/*
	 Details vars
	 
	 Because Swift won't allow us to put these in extensions, we'll define them in the main struct here.
	 
	 The reason we are defining these is because Swift has an issue where a refresh of the data isn't done when the object is
	 created as part of the view. We need to store it and reload the data when required. A pain, sure, but easily overcome and not
	 too far removed from common sense.
	 
	 */
	//@State var pollingDistrictDetails: PollingDistrictDetails = PollingDistrictDetails()
	//@State var wardDetails: WardDetails = WardDetails()
	@State var streetDetails: StreetDetails = StreetDetails()
	@State var subStreetDetails: SubStreetDetails = SubStreetDetails()
	@State var propertyDetails: PropertyDetails = PropertyDetails()
	@State var electorDetails: ElectorDetails = ElectorDetails()
	
	///------------------------------------
	@State var currentAbode: Abode?
	@State var selectedElector: Elector?
	@ObservedObject var confirmationDialog = ConfirmationDialog() { data in
		//OK code
	} onCancel: { data in
		//Cancel code
	}
	
	func closeWindow(window: WindowType) {
		detail = detail.filter {$0 != window}
	}
	
	/// When we open views we keep them in a stack so we can grab the latest one and go back to the previous one when we close the current.
	@State var detail: [WindowType] = []
	/// Toggle flag for UI updates
	@ObservedObject var updater = Updater()
	
	/// Our access to iCloud
    let persistenceController = PersistenceController.shared

	func onShow() {
//		let pd = PollingDistrict.getAll()
//		print(pd.first?.name ?? "")
//		if pd.count == 0 {
//					let bundle = Bundle.main.path(forResource: "Migration", ofType: "json")
//					if let data = Migration.read(path: bundle!) {
//						data.save()
//					}
//		}
		
		/// Let's get rid of orphaned items. We're never going to see them.
		SubStreet.getAll().filter({$0.street == nil}).forEach { ss in
			ss.managedObjectContext?.delete(ss)
		}
		Abode.getAll().filter({$0.subStreet == nil}).forEach { pr in
			pr.managedObjectContext?.delete(pr)
		}
		Elector.getAll().filter({$0.mainResidence == nil}).forEach { el in
			el.managedObjectContext?.delete(el)
		}
		try? PersistenceController.shared.container.viewContext.save()
	}
	
	/// Left-side tree of everything we can navigate
	@State var tree = TreeView()
	
	func electorArea() -> AnyView {
		if currentAbode != nil {
			print("Have an abode!")
		}
		return AnyView(EmptyView().frame(maxHeight:100))
	}
	
	@State private var searchText = ""
	

    var body: some Scene {
        WindowGroup {
			NavigationSplitView {
				///We always have our tree to the left
				ScrollView {
					TreeViewUI(options: TreeViewUIOptions(), treeView: tree, dataProvider: self, contextMenuDelegate: self, treeViewUIDelegate: self)
						.environment(\.managedObjectContext, persistenceController.container.viewContext)
						.searchable(text: $searchText)
				}
			} detail: {
				VSplitView {
					Group {
						latestWindow()
					}
					Group {
						electorArea()
					}
				}
				
			}
			.onAppear {
				tree.notifyDelegate = self
				///We need this to find nodes in our tree
				tree.dataComparer = { a, b in
					if let a = a as? NSManagedObject, let b = b as? NSManagedObject {
						return a.objectID == b.objectID
					}
					return false
				}
				onShow()
			}
			.confirmationDialog(confirmationDialog.message,
								isPresented: $confirmationDialog.showDialog) {
				
				Button(confirmationDialog.okText, role: .destructive) {
					confirmationDialog.onOK(confirmationDialog.data)
				}
				
			} 

        }
    }
}

class Tree {
	var treeView: TreeViewUI
	
	init(dataProvider: TreeNodeDataProvider, contextMenuDelegate: TreeNodeContextMenuProvider) {
		treeView = TreeViewUI(options: TreeViewUIOptions(), dataProvider: dataProvider, contextMenuDelegate: contextMenuDelegate)
	}
}

extension MacRegisterAppApp : UpdateDataNavigationalDelegate {
	func update(item: DataNavigational?) {
		if let pd = item as? PollingDistrict {
			tree.findNode(data: pd)?.data = pd
		}
		if let wd = item as? Ward {
			tree.findNode(data: wd)?.data = wd
		}
		if let st = item as? Street {
			tree.findNode(data: st)?.data = st
		}
		if let ss = item as? SubStreet {
			tree.findNode(data: ss)?.data = ss
		}
		if let pr = item as? Abode {
			tree.findNode(data: pr)?.data = pr
		}
		updater.toggle = !updater.toggle
	}
	
	
}
