//
//  GetWeatherForecastUseCase.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 16/09/2024.
//

import Foundation
import Factory
import Combine

protocol GetWeatherForecastUseCase {
    func execute(lat: Double, lon: Double, units: String) -> AnyPublisher<WeatherForecast, APIError>
}

class GetWeatherForecastUseCaseImpl: GetWeatherForecastUseCase {

    @Injected(\.weatherRepository) private var weatherRepository

    func execute(lat: Double, lon: Double, units: String) -> AnyPublisher<WeatherForecast, APIError> {
        return weatherRepository.getWeatherForecast(lat: lat, lon: lon, units: units).eraseToAnyPublisher()
    }
}
