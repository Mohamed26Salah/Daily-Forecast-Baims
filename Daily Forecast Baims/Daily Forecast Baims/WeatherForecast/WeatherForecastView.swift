//
//  WeatherForecastView.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 16/09/2024.
//


import SwiftUI

public struct WeatherForecastView: View {
    @StateObject var viewModel: WeatherForecastViewModel
    
    public init() {
        self._viewModel = StateObject(wrappedValue: .init())
    }
    
    public var body: some View {
        VStack {
            CitiesDropDown(selectedCity: $viewModel.selectedCity, cities: viewModel.cities)
            if viewModel.weatherForecast != nil {
                dataIsNotAccurateView
                
                weatherListScrollView
                    .padding(.top, -20)
                    .redactedLoading(isLoading: $viewModel.isWeatherForecastLoading)
            } else {
                ErrorView {
                    guard let selectedCity = viewModel.selectedCity else { return }
                    viewModel.getWeatherForecast(lat: selectedCity.lat, lon: selectedCity.lon)
                }
                Spacer()
            }
           
        }
        .background(.ultraThinMaterial)
    }
    private var weatherListScrollView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.weatherForecast?.list ?? []) { day in
                    WeatherDayView(day: day)
                }
                .padding(.top, 20)
            }
            .padding()
        }
    }
    private var dataIsNotAccurateView: some View {
        Group {
            if viewModel.isDataCached {
                Text("Data is not accurate!")
                    .foregroundColor(.red)
                    .font(.title3)
            }
        }
    }
}

#Preview {
    WeatherForecastView()
}
