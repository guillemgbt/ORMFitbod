//
//  ExerciceListViewController.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 10/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import UIKit

class ExerciseListViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let viewModel = ExerciseListViewModel()
    
    deinit {
        //Checking deinit for memory leak prevention
        Utils.printDebug(sender: self, message: "deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBatItems()
        bindObservables()
    }

    private func bindObservables() {
        bindTitle()
        bindMessage()
        bindIsLoading()
    }
    
    private func bindTitle() {
        viewModel.title.observeInUI { [weak self] (title) in
            Utils.printDebug(sender: self, message: "title update: \(title)")
            self?.title = title
        }
    }
    
    private func bindMessage() {
        viewModel.message.observeInUI { [weak self] (_message) in
            if let message = _message {
                Utils.printDebug(sender: self, message: "message update: \(message)")
                self?.showMessage(title: "", message: message)
            }
        }
    }
    
    private func bindIsLoading() {
        viewModel.isLoading.observeInUI { [weak self] (isLoading) in
            Utils.printDebug(sender: self, message: "isLoading update: \(isLoading)")

            isLoading ? self?.activityIndicator.startAnimating() :
                self?.activityIndicator.stopAnimating()
        }
    }
    
    private func setNavBatItems() {
        self.setActivityIndicator()
    }
    
    private func setActivityIndicator() {
        let barItem = UIBarButtonItem(customView: self.activityIndicator)
        self.navigationItem.setRightBarButton(barItem, animated: false)
    }

}
