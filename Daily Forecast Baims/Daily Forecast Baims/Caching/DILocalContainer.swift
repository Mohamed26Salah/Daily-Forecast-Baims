//
//  DILocalContainer.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 18/09/2024.
//

import Foundation
import Factory

extension Container {
    //MARK: Local
    var weatherDataService : Factory<WeatherDataService> {
        Factory (self) { WeatherDataService() }
    }
}
