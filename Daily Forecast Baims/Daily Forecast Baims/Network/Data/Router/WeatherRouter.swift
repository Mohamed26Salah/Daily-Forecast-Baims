//
//  WeatherRouter.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 16/09/2024.
//


import Foundation
import Alamofire

enum WeatherRouter: RequestBuilder {
    
    case getWeatherForecast(lat: Double, lon: Double, units: String)


    internal var path: String {
        switch self {
        case .getWeatherForecast(let lat, let lon, let units):
            return "forecast"
        }
    }
    
    internal var parameters: Parameters? {
        switch self {
        case .getWeatherForecast(let lat, let lon, let units):
            var params: [String: Any] = [:]
            params["lat"] = lat
            params["lon"] = lon
            params["appid"] = readApiKey()
            params["units"] = units
            return params
        }
    }
    
    internal var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    func readApiKey() -> String? {
        guard let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "") else {
            print("API key file not found")
            return nil
        }
        
        do {
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            
            let components = content.components(separatedBy: "ApiKey: ")
            
            if components.count > 1 {
                return components[1].trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                print("API key format is incorrect")
                return nil
            }
        } catch {
            print("Error reading API key file: \(error)")
            return nil
        }
    }
}
