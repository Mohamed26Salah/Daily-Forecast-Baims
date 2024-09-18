//
//  GetWeatherForecastUseCaseTest.swift
//  Daily Forecast BaimsTests
//
//  Created by Mohamed Salah on 18/09/2024.
//


import Foundation
import XCTest
import Factory
import Combine

@testable import Daily_Forecast_Baims
final class GetWeatherForecastUseCaseTest: XCTestCase {
    
    var getWeatherForecastUseCase: GetWeatherForecastUseCase!
    var mockweatherRepository: MockWeatherForecastRepository!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        super.setUp()
        mockweatherRepository = MockWeatherForecastRepository()
        Container.shared.weatherRepository.register { self.mockweatherRepository }
        getWeatherForecastUseCase = GetWeatherForecastUseCaseImpl()
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        getWeatherForecastUseCase = nil
        mockweatherRepository = nil
        cancellables = nil
        super.tearDown()
    }

    
    func testGetCategories_withPopulatedResponse() {
        // Given
        let mockWeatherForecast = WeatherForecast.mockWeatherForecast()
        MockWeatherForecastRouter.weatherForecastResponse = mockWeatherForecast
        MockWeatherForecastRouter.error = nil
        
        let expectation = self.expectation(description: "Get WeatherForecast with Populated Response")
        
        // When
        getWeatherForecastUseCase.execute(lat: 30.0444, lon: 31.2357, units: "metric")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Unexpected error: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { weatherForecast in
                // Then
                XCTAssertNotNil(weatherForecast)
                XCTAssertEqual(weatherForecast.list.count, mockWeatherForecast.list.count)
                XCTAssertEqual(weatherForecast.id, mockWeatherForecast.id)
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testGetCategories_withErrorResponse() {
        // Given
        let mockError = APIError.decoding
        MockWeatherForecastRouter.weatherForecastResponse = nil
        MockWeatherForecastRouter.error = mockError
        
        let expectation = self.expectation(description: "Get WeatherForecast with Error Response")
        
        // When
        getWeatherForecastUseCase.execute(lat: 30.0444, lon: 31.2357, units: "metric")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error.localizedDescription, mockError.localizedDescription)
                } else {
                    XCTFail("Expected failure but got success")
                }
                expectation.fulfill()
            }, receiveValue: { _ in
                XCTFail("Expected no value")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
