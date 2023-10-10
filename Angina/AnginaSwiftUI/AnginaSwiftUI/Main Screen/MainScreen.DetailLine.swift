//
//  MainScreen.DetailLine.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 21/12/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import SwiftUI

struct MainScreen_DetailLine_Elector: View {
	
	struct Data {
		var Name : String
		var Instruction : String
		var Nationality : String
		var PostalVoter : Bool
		var Over76 : Bool
		
		func iconBackcolor(_ enabled: Bool) -> Color {
			return enabled ? Color("Detail.icon.back.enabled") : Color("Detail.icon.back.disabled")
		}
		
		func iconForecolor(_ enabled: Bool) -> Color {
			return enabled ? Color("Detail.icon.fore.enabled") : Color("Detail.icon.fore.disabled")
		}
	}
	
	var data : MainScreen_DetailLine_Elector.Data
	
	var body: some View {
		HStack(alignment: .top, spacing: 24, content: {
			Image(systemName: "person.fill")
				.resizable()
				.frame(width: 48, height: 48, alignment: .center)
				.padding(.all, 4)
				.foregroundColor(Color("Detail.mainicon.fore"))
				.background(Color("Detail.mainicon.back"))
				.aspectRatio(contentMode: ContentMode.fit)
				.cornerRadius(8)
			VStack(alignment: .leading) {
				Text(data.Name)
					.font(.system(.largeTitle))
				Text(data.Instruction)
			}
			Spacer()
			HStack(alignment: .top, spacing: 8, content: {
				Text(data.Nationality)
					.font(.system(.largeTitle))
				
				Image(systemName: "envelope")
					.resizable()
					.frame(width: 48, height: 48, alignment: .center)
					.padding(.all, 4)
					.background(data.iconBackcolor(data.PostalVoter))
					.foregroundColor(data.iconForecolor(data.PostalVoter))
					.aspectRatio(contentMode: ContentMode.fit)
					.disabled(!data.PostalVoter)
					.cornerRadius(8)

				Image(systemName: "ear")
					.resizable()
					.frame(width: 48, height: 48, alignment: .center)
					.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 4)
					.background(data.iconBackcolor(data.Over76))
					.foregroundColor(data.iconForecolor(data.Over76))
					.aspectRatio(contentMode: ContentMode.fit)
					.disabled(!data.Over76)
					.cornerRadius(8)
			})
			
		})
		.padding([.leading, .trailing], 24)
	}
}

struct MainScreen_DetailLine_Property: View {
	
	struct Data {
		var Name : String
		var Instruction : String
	}
	
	var data : MainScreen_DetailLine_Property.Data

	
	var body: some View {
		HStack(alignment: .top, spacing: 24, content: {
			Image(systemName: "house.fill")
				.resizable()
				.frame(width: 48, height: 48, alignment: .center)
				.padding(.all, 4)
				.foregroundColor(Color("Detail.mainicon.fore"))
				.background(Color("Detail.mainicon.back"))
				.aspectRatio(contentMode: ContentMode.fit)
				.cornerRadius(8)
			VStack(alignment: .leading) {
				Text(data.Name)
					.font(.system(.largeTitle))
				Text(data.Instruction)
			}
			Spacer()
			
			
		})
		.padding([.leading, .trailing], 24)
	}
}

struct MainScreen_DetailLine_Street: View {
	
	struct Data {
		var Name : String
		var Instruction : String
	}
	
	var data : Self.Data
	
	
	var body: some View {
		HStack(alignment: .top, spacing: 24, content: {
			Image(systemName: "figure.walk.diamond.fill")
				.resizable()
				.frame(width: 48, height: 48, alignment: .center)
				.padding(.all, 4)
				.foregroundColor(Color("Detail.mainicon.fore"))
				.background(Color("Detail.mainicon.back"))
				.aspectRatio(contentMode: ContentMode.fit)
				.cornerRadius(8)
			VStack(alignment: .leading) {
				Text(data.Name)
					.font(.system(.largeTitle))
				Text(data.Instruction)
			}
			Spacer()
			
			
		})
		.padding([.leading, .trailing], 24)
	}
}
struct MainScreen_DetailLine_Previews: PreviewProvider {
	
	static var els : [MainScreen_DetailLine_Elector.Data] = [ MainScreen_DetailLine_Elector.Data(Name: "Fred Flintstone", Instruction: "ITR", Nationality: "Australian", PostalVoter: true, Over76: true),
													   MainScreen_DetailLine_Elector.Data(Name: "Wilma S Flintstone", Instruction: "ITR", Nationality: "United States", PostalVoter: false, Over76: true),
													   MainScreen_DetailLine_Elector.Data(Name: "Bam-Bam Flintstone", Instruction: "", Nationality: "Norwegian", PostalVoter: false, Over76: false)]
	
	static var props : [MainScreen_DetailLine_Property.Data] = [
		MainScreen_DetailLine_Property.Data(Name: "11, Berkeley Close", Instruction: "HEF")
	]
	
	static var streets : [MainScreen_DetailLine_Street.Data] = [
		MainScreen_DetailLine_Street.Data(Name: "Berkeley Close", Instruction: "2x HEF, 3x ITR")
	]
	static var previews: some View {
		VStack(alignment: .leading, spacing: 48) {
			ForEach(0..<streets.count, id:\.self) { idx in
				if idx > 0 {
					Divider()
				}
				MainScreen_DetailLine_Street(data: streets[idx])
			}
			ForEach(0..<props.count, id:\.self) { idx in
				if idx > 0 {
					Divider()
				}
				MainScreen_DetailLine_Property(data: props[idx])
			}
			ForEach(0..<els.count, id:\.self) { idx in
				if idx > 0 {
					Divider()
				}
				MainScreen_DetailLine_Elector(data: els[idx])
			}
			
		}
		
	}
}
