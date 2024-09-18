//
//  Daily_Forecast_BaimsUITests.swift
//  Daily Forecast BaimsUITests
//
//  Created by Mohamed Salah on 16/09/2024.
//

import XCTest

final class WeatherViewUITest: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {

    }

    func testCityDropdownSelectionAndWeatherListVisibility(){
        let app = XCUIApplication()
        app.launch()
        
        let cityDropdownButton = app.buttons["CityDropdown"]
        XCTAssert(cityDropdownButton.waitForExistence(timeout: 1.0))
        XCTAssert(app.scrollViews["weatherListScrollView"].waitForExistence(timeout: 1.0))
        XCTAssertFalse(app.groups["dataIsNotAccurateView"].waitForExistence(timeout: 0.5))
        XCTAssertFalse(app.groups["ErrorView"].waitForExistence(timeout: 0.5))
        cityDropdownButton.tap()
        
        let firstCityOption = app.buttons["Cairo"]
        XCTAssert(firstCityOption.waitForExistence(timeout: 1.0))

    }
}
