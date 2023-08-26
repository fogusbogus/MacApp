//
//  Project+View+UI.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 25/08/2023.
//

import SwiftUI
import Foundation

struct Project_View_UI: View {
	
	var projects: [TODOProject] {
		get {
			let ret = TODOProject.getAll()
			if ret.isEmpty {
				TODOProject.assert(name: "Dev Project", context: nil) { project in
					
				}
			}
			return TODOProject.getAll().sorted(by: {$0.name! < $1.name!})
		}
	}
	
	@State var selectedProject: String = ""
	
    var body: some View {
		Picker("Project", selection: $selectedProject) {
			ForEach(projects, id:\.self) { project in
				Text(project.name!).tag(String(describing: project.objectID))
			}
			Text("New project").tag("")
		}
    }
}

struct Project_View_UI_Previews: PreviewProvider {
    static var previews: some View {
        Project_View_UI()
    }
}
