//
//  WeatherForecast.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 16/09/2024.
//

import Foundation

// MARK: - WeatherForecast -

struct WeatherForecast: Decodable, Identifiable {
    let id: Int
    let list: [WeatherDay]

    enum CodingKeys: String, CodingKey {
        case city, list
    }

    enum CityKeys: String, CodingKey {
        case id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let cityContainer = try container.nestedContainer(keyedBy: CityKeys.self, forKey: .city)
        id = try cityContainer.decode(Int.self, forKey: .id)
        
        list = try container.decode([WeatherDay].self, forKey: .list)
    }
    
    init(id: Int, list: [WeatherDay]) {
        self.id = id
        self.list = list
    }
}
// MARK: - WeatherForecast Mock -

extension WeatherForecast {
    static func mockWeatherForecast(id: Int = 1, daysCount: Int = 5) -> WeatherForecast {
        let weatherDays = (1...daysCount).map { i in
            WeatherDay.mockWeatherDay(id: "\(i)", date: "2024-09-\(i < 10 ? "0" : "")\(i) 12:00:00", temperature: Double(20 + i), weatherIcon: "01d", weatherDescription: "Clear sky")
        }
        return WeatherForecast(id: id, list: weatherDays)
    }
}



// MARK: - WeatherDay -

struct WeatherDay: Decodable, Identifiable {
    let id: String
    let date: String
    let temperature: Double
    let weatherIcon: String
    let weatherDescription: String

    enum CodingKeys: String, CodingKey {
        case dt_txt, main, weather
    }

    enum MainKeys: String, CodingKey {
        case temp
    }

    enum WeatherKeys: String, CodingKey {
        case icon, description
    }

    // Custom initializer to decode WeatherDay
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        date = try container.decode(String.self, forKey: .dt_txt)
        id = date
        
        let mainContainer = try container.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        temperature = try mainContainer.decode(Double.self, forKey: .temp)
        
        var weatherContainer = try container.nestedUnkeyedContainer(forKey: .weather)
        let weatherItem = try weatherContainer.nestedContainer(keyedBy: WeatherKeys.self)
        weatherIcon = try weatherItem.decode(String.self, forKey: .icon)
        weatherDescription = try weatherItem.decode(String.self, forKey: .description)
    }
    
    init(id: String, date: String, temperature: Double, weatherIcon: String, weatherDescription: String) {
        self.id = id
        self.date = date
        self.temperature = temperature
        self.weatherIcon = weatherIcon
        self.weatherDescription = weatherDescription
    }
}

// MARK: - WeatherDay Mock -

extension WeatherDay {
    static func mockWeatherDay(id: String = "1", date: String = "2024-09-01 12:00:00", temperature: Double = 25.0, weatherIcon: String = "01d", weatherDescription: String = "Clear sky") -> WeatherDay {
        return WeatherDay(id: id, date: date, temperature: temperature, weatherIcon: weatherIcon, weatherDescription: weatherDescription)
    }
}
