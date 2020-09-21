//
//  Utils.swift
//  Fast News
//
//  Created by Ruyther on 20/09/20.
//  Copyright © 2020 Lucas Moreton. All rights reserved.
//

import UIKit

// MARK: -

class Utils {
    
    // MARK: - Static Methods -

    static func shareInformation(viewController: UIViewController, items: [Any]) {
        let safari = UIActivityExtensions(title: "Open in Safari", image: UIImage(named: "safari")) { items in
            for item in items {
                guard let url = URL(string: "\(item)") else {
                    continue
                }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        
        let chrome = UIActivityExtensions(title: "Open in Chrome", image: UIImage(named: "chrome")) { items in
            for item in items {
                guard let url = URL(string: "\(item)".replacingOccurrences(of: "http", with: "googlechrome")) else {
                    continue
                }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        
        var activities = [safari]
        if let url = URL(string: "googlechrome://"),
            UIApplication.shared.canOpenURL(url) {
            activities.append(chrome)
        }
        
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: activities)
        activityViewController.popoverPresentationController?.sourceView = viewController.view
        
        viewController.present(activityViewController, animated: true, completion: nil)
    }
}
