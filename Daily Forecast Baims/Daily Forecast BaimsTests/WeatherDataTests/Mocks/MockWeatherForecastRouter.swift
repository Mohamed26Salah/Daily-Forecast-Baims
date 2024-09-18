//
//  MockWeatherForecastRouter.swift
//  Daily Forecast BaimsTests
//
//  Created by Mohamed Salah on 18/09/2024.
//

import Foundation
import Combine

@testable import Daily_Forecast_Baims
class MockWeatherForecastRouter {
    static var weatherForecastResponse: WeatherForecast? = nil
    static var error: APIError? = nil

    static func getWeatherForecast(lat: Double, lon: Double, units: String) -> AnyPublisher<WeatherForecast, APIError> {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        if let response = weatherForecastResponse {
            return Just(response)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: APIError.unknown)
                .eraseToAnyPublisher()
        }
    }
}

