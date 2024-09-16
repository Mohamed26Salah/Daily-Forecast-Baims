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

    private var cancellables = Set<AnyCancellable>()

    
    public init() {
        getWeatherForecast()
    }
}

//MARK: - Api Calls -

extension WeatherForecastViewModel {
    public func getWeatherForecast() {
//        reportingAnIssueLoading = true
        getWeatherForecastUseCase.execute(lat: 30.7956597, lon: 30.7956597, units: UnitsEnum.metric.rawValue)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
//                self.reportingAnIssueLoading = false
                switch completion {
                case .failure(let error):
                    AlertManager.show(message: error.localizedDescription)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else {return}
//                self.reportingAnIssueLoading = false
//                self.showSuccessReportAnIssueView = true
                print("Salah I got \(response)")
            })
            .store(in: &cancellables)
    }
}
