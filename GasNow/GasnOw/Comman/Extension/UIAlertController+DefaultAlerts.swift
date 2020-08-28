//
//  UIAlertController+DefaultAlerts.swift
//  chatapp
//
//  Created by Kris Rudolph  on 2/9/17.
//  Copyright © 2017 Outlook Amusements, Inc. All rights reserved.
//

import UIKit
import SafariServices

extension UIAlertController {
    static let okActionLocalized: String = "OK"
    static let cancelActionLocalized = "Cancel"
    static let dismissActionLocalized = "Dismiss"
    static let loginActionLocalized = "Login"
    static let tryAgainActionLocalized = "Try Again"
    static let deleteAction = "Delete"

    
    static let closeActionLocalized = "Close"
    static let retryActionLocalized = "Retry"

    static func showAlert(_ alert: UIAlertController, in viewController: UIViewController? = nil) {
        var vc = viewController
        
        if vc == nil {
            let rootVC = UIApplication.shared.keyWindow?.rootViewController
            
            
            if let nav = rootVC as? UINavigationController {
                vc = nav.visibleViewController
            }
            
            if let tab = rootVC as? UITabBarController {
                if let selected = tab.selectedViewController {
                    vc = selected
                }
            }
            
            if let presented = rootVC?.presentedViewController {
                vc = presented
            }
        }
        
        vc?.present(alert, animated: true)
    }
    
    
    /// Defaults to showing in currently active view controller
    static func showRequestFailDialog(message: String, in viewController: UIViewController? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: "Server Unresponsive",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: okActionLocalized, style: .default, handler: handler))
        showAlert(alert, in: viewController)
    }
    
    static func showServerFailedDialog(in viewController: UIViewController? = nil) {
        showRequestFailDialog(message: "The server is not responding. Please try again later.", in: viewController)
    }
    
    
    static func showErrorDailog(message: String, in viewController: UIViewController? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: "Alert",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: okActionLocalized, style: .default, handler: handler))
        alert.view.tintColor = UIColor.orange
        showAlert(alert, in: viewController)
    }
    
    static func showNoConnectionDialog(in viewController: UIViewController? = nil) {
        let alert = UIAlertController(title: "Alert",
                                      message: "Check your network settings and try again",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: okActionLocalized, style: .default))
        alert.view.tintColor = UIColor.orange
        showAlert(alert, in: viewController)
    }
    //Defaul alert
 static func popupAlert(in viewController: UIViewController? = nil,title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .destructive, handler: actions[index])
            alert.addAction(action)
        }
      alert.view.tintColor = UIColor.orange
        showAlert(alert, in: viewController)
    }
}

