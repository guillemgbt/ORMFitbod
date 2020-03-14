//
//  ExerciseStatsViewController.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 13/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import UIKit

class ExerciseStatsViewController: UIViewController {
    
    @IBOutlet weak var exerciceNameLabel: UILabel!
    @IBOutlet weak var exercice1RMValueLabel: UILabel!
    @IBOutlet weak var exercice1RMDescriptionLabel: UILabel!
    

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
