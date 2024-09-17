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
}
