//
//  WeatherRepositoryTest.swift
//  Daily Forecast BaimsTests
//
//  Created by Mohamed Salah on 18/09/2024.
//

import Foundation
import XCTest
import Combine

@testable import Daily_Forecast_Baims
final class WeatherRepositoryTest: XCTestCase {
    
    var weatherRepository: WeatherRepository!
    
    override func setUpWithError() throws {
        super.setUp()
        weatherRepository = WeatherRepositoryImpl()
    }
    
    override func tearDownWithError() throws {
        weatherRepository = nil
        super.tearDown()
    }
    
    func testGetWeatherForecast_returnsPublisher() {
        let expectation = self.expectation(description: "Get weatherForecast")
        var cancellable: AnyCancellable?
        
        cancellable = weatherRepository.getWeatherForecast(lat: 30.0444, lon: 31.2357, units: "metric")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Error: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { response in
                XCTAssertNotNil(response)
            })
        
        waitForExpectations(timeout: 2.0, handler: nil)
        cancellable?.cancel()
    }
    
}
