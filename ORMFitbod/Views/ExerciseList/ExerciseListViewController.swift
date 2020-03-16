//
//  ExerciceListViewController.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 10/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import UIKit

class ExerciseListViewController: ORMThemeViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = ExerciseListViewModel()
    
    deinit {
        //Checking deinit for memory leak prevention
        Utils.printDebug(sender: self, message: "deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBatItems()
        setTableView()
        bindObservables()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.deselectCurrentRow()
    }

    private func bindObservables() {
        bindTitle()
        bindMessage()
        bindIsLoading()
        bindExercicesUpdates()
        bindSelectedExercise()
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
    
    private func bindExercicesUpdates() {
        viewModel.exercisesUpdate.observeInUI { [weak self] (update) in
            self?.tableView.reloadData()
        }
    }
    
    
    /// This is not the best way to handle the VC creation.
    /// A better approach would be to have a cache or a local database and
    /// initialise the VC with the model primary key and let its view model
    /// refetch it.
    private func bindSelectedExercise() {
        viewModel.selectedExercise.observeInUI { [weak self] (_exercise) in
            guard let exercise = _exercise else { return }
            self?.push(ExerciseStatsViewController(exercise: exercise))
        }
    }
    
    private func setNavBatItems() {
        self.setActivityIndicator()
    }
    
    private func setActivityIndicator() {
        let barItem = UIBarButtonItem(customView: self.activityIndicator)
        self.navigationItem.setRightBarButton(barItem, animated: false)
    }
    
    private func setTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        ExerciseListCellType.registerNibs(in: tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension ExerciseListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModel.cellType(at: indexPath)
        return cellType?.dequeueCell(for: tableView, at: indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.handleExerciseSelection(at: indexPath)
    }

}
