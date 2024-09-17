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
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.weatherForecast?.list ?? []) { day in
                        WeatherDayView(day: day)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
            .padding(.top, -20)
        }
        .background(.ultraThinMaterial)
    }
}

#Preview {
    WeatherForecastView()
}
