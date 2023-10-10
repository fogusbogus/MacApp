//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Matt Hogg on 08/12/2020.
//

import SwiftUI

struct DayTemp {
	var day: String
	var image: String
	var temp: Int
}

struct ContentView: View {
	
	@State private var isNight = false
	
	var dayTemps : [DayTemp] = [
		DayTemp(day:"TUE", image:"cloud.sun.fill", temp:74),
		DayTemp(day:"WED", image:"sun.max.fill", temp:88),
		DayTemp(day:"THU", image:"wind.snow", temp:55),
		DayTemp(day:"FRI", image:"sunset.fill", temp:60),
		DayTemp(day:"SAT", image:"snow", temp:25)
	]
	
	var body: some View {
		ZStack {
			BackgroundView(isNight: isNight)
			VStack {
				CityTextView(cityName: "Cupertino, CA")
				
				MainWeatherStatusView(imageName: "cloud.sun.fill", temperature: 76, scale: "F")
				
				HStack(spacing: 20) {
					ForEach(0..<dayTemps.count, id: \.self) { item in
						let dayTemp = dayTemps[item]
						WeatherDayView(dayOfWeek: dayTemp.day, imageName: dayTemp.image, temperature: dayTemp.temp)
					}
				}
				Spacer()
				
				Button {
					isNight.toggle()
				} label: {
					WeatherButton(prompt: "Change Day Time", textColor: .blue, backgroundColor: .white)
				}
				Spacer()
			}
		}
		.foregroundColor(Color("Text"))
	}
}

struct WeatherDayView : View {
	var dayOfWeek: String
	var imageName: String
	var temperature: Int
	var body: some View {
		VStack(spacing: 4) {
			Text(dayOfWeek)
				.padding()
				.font(.system(size: 16, weight: .medium, design: .default))
			Image(systemName: imageName)
				.renderingMode(.original)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 40, height: 40)
			Text("\(temperature)°")
				.font(.system(size: 28, weight: .medium, design: .default))
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

struct BackgroundView: View {
	var isNight = false
	
	var repos : String {
		get {
			if isNight {
				return "ColorsNight"
			}
			return "Colors"
		}
	}
	var body: some View {
		LinearGradient(gradient: Gradient(colors: [Color("\(repos).GradStart"), Color("\(repos).GradEnd")]),
					   startPoint: .topLeading,
					   endPoint: .bottomTrailing)
			.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
	}
}

struct CityTextView: View {
	var cityName: String
	var body: some View {
		Text(cityName)
			.font(.system(size: 32, weight: .medium, design: .default))
			.padding()
	}
}

struct MainWeatherStatusView: View {
	
	var imageName: String
	var temperature: Int
	var scale: String = "F"
	
	var body: some View {
		VStack(spacing: 10) {
			Image(systemName: imageName)
				.renderingMode(.original)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 180, height: 180)
			Text("\(temperature)° \(scale)")
				.font(.system(size: 70, weight: .medium))
		}
		.padding(.bottom, 40)
	}
}

struct WeatherButton: View {
	var prompt: String
	var textColor: Color
	var backgroundColor: Color
	
	var body: some View {
		Text(prompt)
			.frame(width: 280, height: 50)
			.background(backgroundColor)
			.foregroundColor(textColor)
			.font(.system(size: 20, weight: .bold, design: .default))
			.cornerRadius(10)
	}
}
