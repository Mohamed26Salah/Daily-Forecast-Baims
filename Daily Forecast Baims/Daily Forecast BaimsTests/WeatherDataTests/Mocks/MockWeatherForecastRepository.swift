//
//  MockWeatherForecastRepository.swift
//  Daily Forecast BaimsTests
//
//  Created by Mohamed Salah on 18/09/2024.
//


import Foundation
import Combine
@testable import Daily_Forecast_Baims

class MockWeatherForecastRepository: WeatherRepository {
    func getWeatherForecast(lat: Double, lon: Double, units: String) -> AnyPublisher<WeatherForecast, APIError> {
        return MockWeatherForecastRouter.getWeatherForecast(lat: lat, lon: lon, units: units)
    }
}
