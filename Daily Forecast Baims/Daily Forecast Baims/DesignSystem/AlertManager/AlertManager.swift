//
//  AlertManager.swift
//  Daily Forecast Baims
//
//  Created by Mohamed Salah on 16/09/2024.
//

import Combine
import SwiftUI
import UIKit

public class AlertManager {
    public class func show(
        title: String = "error",
        message: String,
        primaryButtonTitle: String = "ok",
        primaryButtonAction: @escaping () -> Void = {},
        secondaryButtonTitle: String? = nil,
        secondaryButtonAction: (() -> Void)? = nil
    ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let primaryAction = UIAlertAction(title: primaryButtonTitle, style: .default) { (action: UIAlertAction) in
            primaryButtonAction()
        }
        alertVC.addAction(primaryAction)
        
        if let secondaryButtonTitle = secondaryButtonTitle {
            let secondaryAction = UIAlertAction(title: secondaryButtonTitle, style: .cancel) { (action: UIAlertAction) in
                secondaryButtonAction?()
            }
            alertVC.addAction(secondaryAction)
        }
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.last,
           let rootViewController = window.rootViewController {
            var topController = rootViewController
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            if topController is UIAlertController {
                // If the topController is already a UIAlertController, don't present another one
                return
            }
            
            topController.present(alertVC, animated: true, completion: nil)
        }
    }
}
