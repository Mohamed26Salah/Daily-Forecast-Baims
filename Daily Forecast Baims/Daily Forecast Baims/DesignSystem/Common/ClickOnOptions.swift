//
//  ClickOnOptions.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 17/09/2024.
//


import Foundation
import UIKit
import SwiftUI
import MapKit

class ClickOnActions{
    static func triggerHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    static func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
}
