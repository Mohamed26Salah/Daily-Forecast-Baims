//
//  GetCitiesUseCaseTest.swift
//  Daily Forecast BaimsTests
//
//  Created by Mohamed Salah on 18/09/2024.
//


import Foundation
import XCTest
import Factory
import Combine

@testable import Daily_Forecast_Baims
final class GetCitiesUseCaseTest: XCTestCase {
    
    var getCitiesUseCase: GetCitiesUseCase!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        super.setUp()
        getCitiesUseCase = GetCitiesUseCaseImpl()
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        getCitiesUseCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testGetCitiesSuccess() {
        // Arrange
        let expectedCities: [CityJson] = [
            CityJson(id: 1, cityNameAr: "القاهرة", cityNameEn: "Cairo", lat: 30.0444, lon: 31.2357),
            CityJson(id: 2, cityNameAr: "دبي", cityNameEn: "Dubai", lat: 25.2048, lon: 55.2708),
            CityJson(id: 3, cityNameAr: "باريس", cityNameEn: "Paris", lat: 48.8566, lon: 2.3522),
            CityJson(id: 4, cityNameAr: "لندن", cityNameEn: "London", lat: 51.5074, lon: -0.1278),
            CityJson(id: 5, cityNameAr: "نيويورك", cityNameEn: "New York", lat: 40.7128, lon: -74.006),
            CityJson(id: 6, cityNameAr: "طوكيو", cityNameEn: "Tokyo", lat: 35.6762, lon: 139.6503),
            CityJson(id: 7, cityNameAr: "سنغافورة", cityNameEn: "Singapore", lat: 1.3521, lon: 103.8198),
            CityJson(id: 8, cityNameAr: "ريو دي جانيرو", cityNameEn: "Rio de Janeiro", lat: -22.9068, lon: -43.1729),
            CityJson(id: 9, cityNameAr: "سيدني", cityNameEn: "Sydney", lat: -33.8688, lon: 151.2093),
            CityJson(id: 10, cityNameAr: "موسكو", cityNameEn: "Moscow", lat: 55.7558, lon: 37.6173)
        ]
        
        let expectation = self.expectation(description: "Completion handler called")
        
        // Act
        getCitiesUseCase.execute { result in
            switch result {
            case .success(let cities):
                XCTAssertEqual(cities.first?.cityNameEn, expectedCities.first?.cityNameEn, "Cities should be equal to expected cities")
            case .failure(let error):
                XCTFail("Expected success but got failure with error: \(error)")
            }
            expectation.fulfill()
        }
        
        // Assert
        waitForExpectations(timeout: 1.0, handler: nil)
    }

}
