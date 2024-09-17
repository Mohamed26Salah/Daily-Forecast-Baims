//
//  UseCase.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 16/09/2024.
//

import Foundation
import Factory

extension Container {
    //MARK: Local
    var localDataProvider : Factory<LocalProvider> {
        Factory (self) { LocalProviderImpl() }
    }
    
    //MARK: Repositories
    var weatherRepository: Factory<WeatherRepository> {
        Factory(self) { WeatherRepositoryImpl() }
    }
   
    //MARK: UseCases
    var getWeatherForecastUseCase: Factory<GetWeatherForecastUseCase> {
        Factory(self) { GetWeatherForecastUseCaseImpl() }
    }
    var getCitiesUseCase: Factory<GetCitiesUseCase> {
        Factory(self) { GetCitiesUseCaseImpl() }
    }
    
}
