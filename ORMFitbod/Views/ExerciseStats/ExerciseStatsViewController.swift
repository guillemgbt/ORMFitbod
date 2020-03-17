//
//  ExerciseStatsViewController.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 13/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import UIKit
import SwiftCharts


class ExerciseStatsViewController: ORMThemeViewController {
    
    @IBOutlet weak var exerciceNameLabel: UILabel!
    @IBOutlet weak var exercice1RMValueLabel: UILabel!
    @IBOutlet weak var exercice1RMDescriptionLabel: UILabel!
    @IBOutlet weak var chartContainerView: UIView!
    @IBOutlet weak var chartInfoLabel: UILabel!
    
    private let viewModel: ExerciseStatsViewModel
    
    /// This is not the best way to handle the VC creation.
    /// A better approach would be to have a cache or a local database and
    /// initialise the VC with the model primary key and let its view model
    /// refetch it.
    init(exercise: Exercise) {
        self.viewModel = ExerciseStatsViewModel(exercise: exercise)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder not implemented.")
    }
    
    deinit {
        //Check deinit for memory leaks prevention
        Utils.printDebug(sender: self, message: "deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTheme()
        bindObservables()
        DispatchQueue.main.async { //So it creates the chart when view is autolayout
            self.viewModel.prepareChartInBackground(bounds: self.chartContainerView.bounds)
        }
    }
    
    private func setTheme() {
        let theme = ThemeManager.shared.current()
        self.exerciceNameLabel.textColor = theme.titleTextColor
        self.exercice1RMValueLabel.textColor = theme.titleTextColor
        self.exercice1RMDescriptionLabel.textColor = theme.subtitleTextColor
        self.chartInfoLabel.textColor = theme.subtitleTextColor
    }
    
    private func bindObservables() {
        bindName()
        bindDescription1RM()
        bindValue1RM()
        bindChart()
    }
    
    private func bindName() {
        viewModel.name.observeInUI { [weak self] (name) in
            self?.exerciceNameLabel.text = name
        }
    }
    
    private func bindDescription1RM() {
        viewModel.description1RM.observeInUI { [weak self] (description) in
            self?.exercice1RMDescriptionLabel.text = description
        }
    }
    
    private func bindValue1RM() {
        viewModel.value1RM.observeInUI { [weak self] (value) in
            self?.exercice1RMValueLabel.text = value
        }
    }
    
    private func bindChart() {
        viewModel.chart.observeInUI { [weak self] (_chart) in
            guard let chart = _chart else { return }
            _ = self?.chartContainerView.subviews.map({ $0.removeFromSuperview() })
            self?.chartContainerView.addSubview(chart.view)
        }
    }
    
}
