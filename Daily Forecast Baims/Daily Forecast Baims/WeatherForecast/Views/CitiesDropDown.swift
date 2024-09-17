//
//  CitiesDropDown.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 17/09/2024.
//

import SwiftUI

struct CitiesDropDown: View {
    @Binding var selectedCity: CityJson?
    let cities: [CityJson]
    
    var body: some View {
        Menu {
            ForEach(cities) { city in
                Button(action: {
                    selectedCity = city
                }) {
                    Text(city.cityNameEn)
                    if city.id == selectedCity?.id {
                        Image(systemName: "checkmark")
                    }
                }
            }
        } label: {
            HStack {
                Text(selectedCity?.cityNameEn ?? "Select a city")
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.down")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
    }
}

