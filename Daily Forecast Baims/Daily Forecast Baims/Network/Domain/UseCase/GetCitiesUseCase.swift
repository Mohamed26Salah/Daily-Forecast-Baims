//
//  GetCitiesUseCase.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 17/09/2024.
//

import Foundation
import Foundation
import Factory

protocol GetCitiesUseCase {
    func execute(completion: @escaping (Result<[CityJson], Error>) -> Void)
}

class GetCitiesUseCaseImpl: GetCitiesUseCase {
    @Injected(\.localDataProvider) var localDataProvider
    
    func execute(completion: @escaping (Result<[CityJson], Error>) -> Void) {
        localDataProvider.loadJSON(filename: "Cities", type: [CityJson].self, completion: completion)
    }
}
