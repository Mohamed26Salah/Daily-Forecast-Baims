//
//  WeatherForecastViewModel.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 16/09/2024.
//


import Foundation
import SwiftUI
import Factory
import Combine

class WeatherForecastViewModel: ObservableObject {
    @Injected(\.getWeatherForecastUseCase) private var getWeatherForecastUseCase
    @Injected(\.getCitiesUseCase) private var getCitiesUseCase
    @Injected(\.weatherDataService) private var weatherDataService

    @Published var cities: [CityJson] = []
    @Published var selectedCity: CityJson?
    @Published var weatherForecast: WeatherForecast?
    @Published var isWeatherForecastLoading: Bool = true
    @Published var isDataCached: Bool = false
    
    private var cancellables = Set<AnyCancellable>()

    
    public init() {
        getCities()
        susbcribeSelectedCity()
    }
}
//MARK: - Subscribe To Publishers Changes -

extension WeatherForecastViewModel {
    private func susbcribeSelectedCity() {
        $selectedCity
            .compactMap { $0 }
            .sink { [weak self] city in
                guard let self = self else { return }
                self.getWeatherForecast(lat: city.lat, lon: city.lon)
            }
            .store(in: &cancellables)
    }
}


//MARK: - Subscribe To Publishers Changes -

extension WeatherForecastViewModel {
    private func manageRedactedAnimation() {
        self.isWeatherForecastLoading = true
        self.weatherForecast = WeatherForecast.mockWeatherForecast()
    }
}

//MARK: - Api Calls -

extension WeatherForecastViewModel {
    public func getWeatherForecast(lat: Double, lon: Double) {
        manageRedactedAnimation()
        getWeatherForecastUseCase.execute(lat: lat, lon: lon, units: UnitsEnum.metric.rawValue)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
//                    AlertManager.show(message: error.localizedDescription)
                    if let selectedCityId = self.selectedCity?.id {
                        self.weatherForecast = self.weatherDataService.fetchWeatherForecast(by: selectedCityId)
                        self.isDataCached = true
                    }
                    self.isWeatherForecastLoading = false
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else {return}
                withAnimation {
                    self.weatherForecast = response
                    self.isDataCached = false
                    if let selectedCityId = self.selectedCity?.id {
                        self.weatherDataService.cacheWeatherForecast(response, forCityId: selectedCityId)
//                        print("Salah Saved \(self.weatherDataService.fetchWeatherForecast(by: selectedCityId))")
                    }
                    self.isWeatherForecastLoading = false
                }
                print("Salah I got \(response)")
            })
            .store(in: &cancellables)
    }
}

//MARK: - Local Api Calls -

extension WeatherForecastViewModel {
    public func getCities() {
        getCitiesUseCase.execute { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let cities):
                self.cities = cities
                self.selectedCity = cities.first
                print("Salah cities are \(cities)")
            case .failure(let error):
                AlertManager.show(message: error.localizedDescription)
            }
        }
    }
}

//MARK: - Helper Functions -

extension WeatherForecastViewModel {

}


