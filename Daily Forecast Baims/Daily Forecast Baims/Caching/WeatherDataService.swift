//
//  WeatherDataService.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 18/09/2024.
//

import Foundation
import CoreData

class WeatherDataService {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    
    //MARK: Cache using the city ID
    func cacheWeatherForecast(_ weatherForecast: WeatherForecast, forCityId cityId: Int) {
        if let _ = fetchWeatherForecast(by: cityId) {
            print("Weather forecast for city with id \(cityId) already exists. Updating...")
            updateWeatherForecast(weatherForecast, forCityId: cityId)
        } else {
            print("Caching new weather forecast for city with id \(cityId).")
            addWeatherForecast(weatherForecast, forCityId: cityId)
        }
    }
    
    //MARK: Add WeatherForecast
    func addWeatherForecast(_ weatherForecast: WeatherForecast, forCityId cityId: Int) {
        let forecastEntity = WeatherForecastEntity.from(weatherForecast: weatherForecast, context: context)
        forecastEntity.id = Int32(cityId)
        
        do {
            try context.save()
            print("Weather forecast inserted successfully.")
        } catch {
            print("Error saving new weather forecast: \(error)")
        }
    }
    
    //MARK: Update WeatherForecast
    func updateWeatherForecast(_ weatherForecast: WeatherForecast, forCityId cityId: Int) {
        let fetchRequest: NSFetchRequest<WeatherForecastEntity> = WeatherForecastEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", cityId)
        
        do {
            let forecastEntities = try context.fetch(fetchRequest)
            if let existingForecast = forecastEntities.first {
                existingForecast.list = NSSet(array: weatherForecast.list.map {
                    WeatherDayEntity.from(weatherDay: $0, forecast: existingForecast, context: context)
                })
                try context.save()
                print("Weather forecast updated successfully.")
            }
        } catch {
            print("Error updating weather forecast: \(error)")
        }
    }
    
    //MARK: Fetch WeatherForecast
    func fetchWeatherForecast(by cityId: Int) -> WeatherForecast? {
        let fetchRequest: NSFetchRequest<WeatherForecastEntity> = WeatherForecastEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", cityId)
        
        do {
            let forecastEntities = try context.fetch(fetchRequest)
            if let forecastEntity = forecastEntities.first {
                return WeatherForecast.from(weatherForecastEntity: forecastEntity)
            }
        } catch {
            print("Error fetching forecast for city with ID \(cityId): \(error)")
        }
        return nil
    }
    
}

// MARK: - WeatherForecast -> WeatherForecastEntity Conversion -
extension WeatherForecastEntity {
    static func from(weatherForecast: WeatherForecast, context: NSManagedObjectContext) -> WeatherForecastEntity {
        let forecastEntity = WeatherForecastEntity(context: context)
        forecastEntity.id = Int32(weatherForecast.id)
        
        let weatherDayEntities = weatherForecast.list.map { WeatherDayEntity.from(weatherDay: $0, forecast: forecastEntity, context: context) }
        forecastEntity.addToList(NSSet(array: weatherDayEntities))
        
        return forecastEntity
    }
}

// MARK: - WeatherDay -> WeatherDayEntity Conversion -

extension WeatherDayEntity {
    static func from(weatherDay: WeatherDay, forecast: WeatherForecastEntity, context: NSManagedObjectContext) -> WeatherDayEntity {
        let dayEntity = WeatherDayEntity(context: context)
        dayEntity.id = weatherDay.id
        dayEntity.date = weatherDay.date
        dayEntity.temperature = weatherDay.temperature
        dayEntity.weatherIcon = weatherDay.weatherIcon
        dayEntity.weatherDescription = weatherDay.weatherDescription
        return dayEntity
    }
}

// MARK: - WeatherForecastEntity -> WeatherForecast Conversion
extension WeatherForecast {
    static func from(weatherForecastEntity: WeatherForecastEntity) -> WeatherForecast {
        let id = Int(weatherForecastEntity.id)
        
        let weatherDays = (weatherForecastEntity.list as? Set<WeatherDayEntity>)?.map { WeatherDay.from(weatherDayEntity: $0) } ?? []
        
        return WeatherForecast(id: id, list: weatherDays)
    }
}

// MARK: - WeatherDayEntity -> WeatherDay Conversion
extension WeatherDay {
    static func from(weatherDayEntity: WeatherDayEntity) -> WeatherDay {
        return WeatherDay(
            id: weatherDayEntity.id ?? "",
            date: weatherDayEntity.date ?? "",
            temperature: weatherDayEntity.temperature,
            weatherIcon: weatherDayEntity.weatherIcon ?? "",
            weatherDescription: weatherDayEntity.weatherDescription ?? ""
        )
    }
}
