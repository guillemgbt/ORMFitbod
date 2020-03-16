//
//  ExerciseCell.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 13/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import UIKit

class ExerciseCell: ORMThemeCell, NibLoadableView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var oneRepMaxValueLabel: UILabel!
    @IBOutlet weak var oneRepMaxDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let theme = ThemeManager.shared.current()
        nameLabel.textColor = theme.titleTextColor
        oneRepMaxValueLabel.textColor = theme.titleTextColor
        oneRepMaxDescriptionLabel.textColor = theme.subtitleTextColor
    }
    
    func set(with exercise: Exercise) {
        self.nameLabel.text = exercise.name
        self.oneRepMaxValueLabel.text = "\(Int(exercise.get1RM()))"
    }
}
