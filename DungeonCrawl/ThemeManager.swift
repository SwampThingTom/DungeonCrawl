//
//  AppearanceManager.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/24/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import UIKit

protocol ThemeProviding {
    
    var alertBackgroundColor: UIColor { get }
    var alertTextColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var barTintColor: UIColor { get }
    var textColor: UIColor { get }
    var tintColor: UIColor { get }
}

class ThemeManager {
    
    static func apply(_ theme: ThemeProviding = DefaultTheme()) {
        
        // Global tintColor
        
        UIView.appearance().tintColor = theme.tintColor
        
        // UIAlertView
        
        let alertViewAppearance = UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self])
        alertViewAppearance.backgroundColor = theme.alertBackgroundColor
        
        let alertViewLabelAppearance = UILabel.appearance(whenContainedInInstancesOf: [UIAlertController.self])
        alertViewLabelAppearance.themedTextColor = theme.alertTextColor
        
        // UINavigationBar
        
        UINavigationBar.appearance().barTintColor = theme.barTintColor
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: theme.tintColor
        ]
        
        // UITableView
        
        UITableView.appearance().backgroundColor = theme.backgroundColor
        UITableViewCell.appearance().backgroundColor = theme.backgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableView.self]).themedTextColor = theme.textColor
    }
}

struct DefaultTheme: ThemeProviding {
    
    var alertBackgroundColor: UIColor {
        return .darkGray
    }
    
    var alertTextColor: UIColor {
        return .white
    }
    
    var backgroundColor: UIColor {
        return .black
    }

    var barTintColor: UIColor {
        return UIColor(red: 132, green: 76, blue: 51, alpha: 1.0)
    }
    
    var textColor: UIColor {
        return .lightGray
    }
    
    var tintColor: UIColor {
        return .white
    }
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
}

extension UILabel {
    
    /// `UIAppearance` compatible property to customize `UILabel.textColor`.
    /// See: https://stackoverflow.com/a/57630581/2348392
    @objc dynamic var themedTextColor: UIColor {
        get {
            return textColor
        }
        set {
            textColor = newValue
        }
    }
}
