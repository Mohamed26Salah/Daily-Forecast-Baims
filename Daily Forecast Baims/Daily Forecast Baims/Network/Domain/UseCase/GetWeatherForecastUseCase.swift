//
//  GetWeatherForecastUseCase.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 16/09/2024.
//

import Foundation
import Factory
import Combine

public protocol GetWeatherForecastUseCase {
    func execute() -> AnyPublisher<[City]?, APIError>
}

class GetWeatherForecastUseCaseImpl: GetWeatherForecastUseCase {

    @Injected(\.weatherRepository) private var merchantRepository

    func execute() -> AnyPublisher<[City]?, APIError> {
        return merchantRepository.getCities().eraseToAnyPublisher()
    }
}
