//
//  WeatherForecastViewModelTest.swift
//  Daily Forecast BaimsTests
//
//  Created by Mohamed Salah on 18/09/2024.
//



import Foundation
import XCTest
import Factory
import Combine

@testable import Daily_Forecast_Baims
class WeatherForecastViewModelTest: XCTestCase {
        
    var viewModel: WeatherForecastViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        super.setUp()
        cancellables = []
        viewModel = WeatherForecastViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    func testGetWeatherForecast() {
        let expectation = expectation(description: "Get WeatherForecast")
        
        viewModel.$weatherForecast
            .compactMap{$0}
            .dropFirst() //Mock Data for redacted animation
            .sink { weatherForecast in
                expectation.fulfill()
                
                XCTAssertFalse(weatherForecast.list.isEmpty)
            }
            .store(in: &cancellables)
        
        viewModel.getWeatherForecast(lat: 30.0444, lon: 31.2357)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetCities() {
        let expectation = expectation(description: "Get Cities")
        
        viewModel.$cities
            .dropFirst()
            .sink { cities in
                expectation.fulfill()
                
                XCTAssertFalse(cities.isEmpty)
            }
            .store(in: &cancellables)
        
        viewModel.getCities()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

