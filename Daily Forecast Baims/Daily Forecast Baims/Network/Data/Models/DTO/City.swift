//
//  City.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 17/09/2024.
//

import Foundation

// MARK: - City
struct CityJson: Codable {
    var id: Int
    var cityNameAr: String
    var cityNameEn: String
    var lat: Double
    var lon: Double

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case cityNameAr = "cityNameAr"
        case cityNameEn = "cityNameEn"
        case lat = "lat"
        case lon = "lon"
    }
}
