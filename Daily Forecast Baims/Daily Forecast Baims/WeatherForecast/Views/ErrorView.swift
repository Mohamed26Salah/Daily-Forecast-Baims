//
//  ErrorView.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 18/09/2024.
//

import Foundation
import SwiftUI

struct ErrorView: View {
    var retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Something went wrong")
                .font(.headline)
                .foregroundColor(.red)
            
            Button(action: {
                retryAction()
            }) {
                Text("Retry")
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 40) // Padding around the button
        }
        .padding() // Padding for the VStack
    }
}
