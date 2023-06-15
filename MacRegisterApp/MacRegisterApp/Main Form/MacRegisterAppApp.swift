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
	
	@State var currentAbode: Abode?
	@State var selectedElector: Elector?
	
	func closeWindow(window: WindowType) {
		detail = detail.filter {$0 != window}
	}
	
	@State var detail: [WindowType] = []
	@ObservedObject var updater = Updater()

	func openWindow(window: WindowType) {
		detail = detail.filter {$0 != window}
		detail.append(window)
	}
	
	func latestWindow() -> AnyView {
		guard let window = detail.last else { return AnyView(currentWindowForSelection())}
		
		switch window.type {
			case .newSubStreet:
				return AnyView(
					Group {
						NewSubStreet(street: window.object as? Street, delegate: self)
						Spacer()
					})
			case .newWard:
				return AnyView(
					Group {
						NewWard(pollingDistrict: window.object as? PollingDistrict, delegate: self)
						Spacer()
					})
			case .newStreet:
				return AnyView(
					Group {
						NewStreet(ward: window.object as? Ward, delegate: self)
						Spacer()
					})
			case .newPropertyRange:
				let st = window.object as? Street ?? (window.object as? SubStreet)?.street
				let ss = window.object as? SubStreet
				return AnyView(
					Group {
						NewPropertyRange(subStreet: ss, street: st, delegate: self)
						Spacer()
					})
			
			case .newElector:
				return AnyView(
					Group {
						NewElector(property: window.object as? Abode, delegate: self)
						Spacer()
					})
				
			case .editElector:
				return AnyView(
					Group {
						NewElector(property: nil, delegate: self, details: ElectorDetails(object: selectedElector))
						Spacer()
					}
				)

			default:
				return AnyView(currentWindowForSelection())
		}
	}
	
	func currentWindowForSelection() -> AnyView {
		
		if let pd = tree.selectedNode?.data as? PollingDistrict {
			return AnyView(
				Group {
					View_PollingDistrict(data: View_PollingDistrict_Data(pollingDistrict: pd), delegate: self)
					Spacer()
				}
				)
		}
		if let wd = tree.selectedNode?.data as? Ward {
			return AnyView(
				Group {
					View_Ward(data: View_Ward_Data(ward: wd), delegate: self)
					Spacer()
				}
			)
		}
		if let st = tree.selectedNode?.data as? Street {
			return AnyView(
				VStack {
					HStack {
						View_Street(data: View_Street_Data(street: st), delegate: self)
						Spacer()
					}
					HSplitView {
						PropertiesView(street: st, delegate: self, contextMenuDelegate: self)
						View_Electors(property: currentAbode, contextMenuDelegate: self, delegate: self)
					}
				}
			)
		}
		if let ss = tree.selectedNode?.data as? SubStreet {
			return AnyView(
				VStack {
					HStack {
						View_SubStreet(data: View_SubStreet_Data(subStreet: ss), delegate: self)
						Spacer()
					}
					HSplitView {
						PropertiesView(substreet: ss, delegate: self, contextMenuDelegate: self)
						View_Electors(property: currentAbode, contextMenuDelegate: self, delegate: self)
					}
				}
			)
		}
		return AnyView(EmptyView())
	}
	
	
    let persistenceController = PersistenceController.shared

	func onShow() {
		let pd = PollingDistrict.getAll()
		print(pd.first?.name ?? "")
		if pd.count == 0 {
					let bundle = Bundle.main.path(forResource: "Migration", ofType: "json")
					if let data = Migration.read(path: bundle!) {
						data.save()
					}
		}
	}
	
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
				tree.dataComparer = { a, b in
					if let a = a as? NSManagedObject, let b = b as? NSManagedObject {
						return a.objectID == b.objectID
					}
					return false
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