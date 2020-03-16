//
//  ORMThemeViewController.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 16/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import UIKit

class ORMThemeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.setTheme()
    }
}

class ORMThemeCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        setTheme(recursive: false)
    }
}

extension UIView {
    
    func setTheme(recursive: Bool = true) {
        let theme = ThemeManager.shared.current()
        self.backgroundColor = theme.backgroundColor
        self.tintColor = theme.mainColor
        
        if !recursive { return }
        
        self.subviews.forEach { (subView) in
            subView.setTheme()
        }
    }
}
