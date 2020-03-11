//
//  UIViewController+Ext.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 11/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func push(_ viewController: UIViewController, animated: Bool = true, in navigationController: UINavigationController? = nil) {
        
        (navigationController ?? self.navigationController)?.pushViewController(viewController, animated: animated)
    }
    
    func showMessage(title: String, message: String, onCompletion: (() -> ())?=nil){
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: {alert in
                onCompletion?()
            }))
            
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
}

