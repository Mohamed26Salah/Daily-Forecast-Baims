//
//  WeatherDayView.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 17/09/2024.
//

import Foundation
import SwiftUI
struct WeatherDayView: View {
    let day: WeatherDay
    
    var body: some View {
        HStack {
            Image(systemName: weatherIconName(for: day.weatherIcon))
                .font(.system(size: 40))
                .foregroundColor(weatherIconColor(for: day.weatherIcon))
            VStack(alignment: .leading) {
                Text("\(day.temperature, specifier: "%.1f")°C")
                    .font(.subheadline)
                Text(day.weatherDescription)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(day.date.toDisplayDateYYYYMMDD())
                .font(.headline)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .shadow(radius: 0.5)
    }
    
    func weatherIconName(for code: String) -> String {
        switch code {
        case "01d", "01n": return "sun.max.fill" // Clear sky
        case "02d", "02n": return "cloud.sun.fill" // Few clouds
        case "03d", "03n", "04d", "04n": return "cloud.fill" // Cloudy
        case "09d", "09n", "10d", "10n": return "cloud.rain.fill" // Rain
        case "11d", "11n": return "cloud.bolt.fill" // Thunderstorm
        case "13d", "13n": return "snow" // Snow
        case "50d", "50n": return "cloud.fog.fill" // Fog
        default: return "questionmark.circle" // Unknown weather
        }
    }
    func weatherIconColor(for code: String) -> Color {
        switch code {
        case "01d", "01n": return .yellow  // Clear sky (day/night)
        case "02d", "02n": return .orange  // Few clouds (day/night)
        case "03d", "03n", "04d", "04n": return .gray  // Cloudy
        case "09d", "09n", "10d", "10n": return .blue  // Rain
        case "11d", "11n": return .purple  // Thunderstorm
        case "13d", "13n": return .white  // Snow
        case "50d", "50n": return .gray  // Fog
        default: return .gray  // Default to black for unknown conditions
        }
    }
}
