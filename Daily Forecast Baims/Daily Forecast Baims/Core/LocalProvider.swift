//
//  LocalDataProvider.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 17/09/2024.
//

import Foundation

protocol LocalProvider {
    func loadJSON<T: Decodable>(filename: String, type: T.Type, completion: @escaping (Result<T, Error>) -> Void)
}

class LocalProviderImpl: LocalProvider {
    func loadJSON<T: Decodable>(filename: String, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Couldn't find JSON file named \(filename).json"])))
            return
        }
        
        do {
            let jsonData = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
            completion(.success(decodedData))
        } catch {
            completion(.failure(error))
        }
    }
}
