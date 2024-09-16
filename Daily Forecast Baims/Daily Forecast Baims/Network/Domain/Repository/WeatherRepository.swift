//
//  WeatherRepository.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 16/09/2024.
//

import Foundation
import Combine

protocol WeatherRepository {
    func getWeatherForecast(lat: Double, lon: Double, units: String) -> AnyPublisher<WeatherForecast, APIError>
}
