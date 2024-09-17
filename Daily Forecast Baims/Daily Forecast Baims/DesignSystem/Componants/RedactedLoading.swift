//
//  RedactedLoading.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 17/09/2024.
//

import Foundation
import SwiftUI

struct RedactedLoadingModifier: ViewModifier {
    @Binding var isLoading: Bool
    @State private var opacity: Double = 1.0

    func body(content: Content) -> some View {
        content
            .redacted(reason: isLoading ? .placeholder : [])
            .disabled(isLoading)
            .opacity(opacity)
            .onChange(of: isLoading) { newValue in
                if newValue {
                    startOpacityAnimation()
                } else {
                    opacity = 1.0
                }
            }
            .onAppear {
                if isLoading {
                    startOpacityAnimation()
                }
            }
    }

    private func startOpacityAnimation() {
        withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            opacity = 0.3
        }
    }
}

public extension View {
    func redactedLoading(isLoading: Binding<Bool>) -> some View {
        self.modifier(RedactedLoadingModifier(isLoading: isLoading))
    }
}
