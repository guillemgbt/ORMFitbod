//
//  Theme.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 16/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation
import UIKit

enum Theme {
    case white
    case dark
    
    var mainColor: UIColor {
        switch self {
        case .white:
            return UIColor.systemBlue
        case .dark:
            return UIColor.orange
        }
    }

    var barStyle: UIBarStyle {
        switch self {
        case .white:
            return .default
        case .dark:
            return .black
        }
    }


    var backgroundColor: UIColor {
        switch self {
        case .white:
            return UIColor.white
        case .dark:
            return UIColor.black
        }
    }
    
    var titleTextColor: UIColor {
        switch self {
        case .white:
            return UIColor.black
        case .dark:
            return UIColor.white
        }
    }
    var subtitleTextColor: UIColor {
        switch self {
        case .white:
            return UIColor.lightGray
        case .dark:
            return UIColor.lightGray
        }
    }
}

class ThemeManager: NSObject {
    
    static let shared = ThemeManager()
    
    func current() -> Theme {
        return .dark
    }
    
    func applyTheme(theme: Theme = ThemeManager.shared.current()) {

        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.mainColor

        UINavigationBar.appearance().barStyle = theme.barStyle
        UINavigationBar.appearance().tintColor = theme.mainColor
    }
}
